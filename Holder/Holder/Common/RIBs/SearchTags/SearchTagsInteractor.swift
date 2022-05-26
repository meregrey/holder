//
//  SearchTagsInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/12.
//

import CoreData
import RIBs

protocol SearchTagsRouting: ViewableRouting {}

protocol SearchTagsPresentable: Presentable {
    var listener: SearchTagsPresentableListener? { get set }
    func update(with tags: [Tag])
}

protocol SearchTagsListener: AnyObject {
    func searchTagsBackButtonDidTap()
    func searchTagsCancelButtonDidTap(forNavigation isForNavigation: Bool)
    func searchTagsRowDidSelect(forNavigation isForNavigation: Bool)
    func searchTagsDidRemove()
}

protocol SearchTagsInteractorDependency {
    var tagBySearchStream: MutableStream<Tag> { get }
}

final class SearchTagsInteractor: PresentableInteractor<SearchTagsPresentable>, SearchTagsInteractable, SearchTagsPresentableListener {
    
    weak var router: SearchTagsRouting?
    weak var listener: SearchTagsListener?
    
    private let tagRepository = TagRepository.shared
    private let dependency: SearchTagsInteractorDependency
    
    private var tagBySearchStream: MutableStream<Tag> { dependency.tagBySearchStream }
    
    init(presenter: SearchTagsPresentable, dependency: SearchTagsInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        performFetch()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func backButtonDidTap() {
        listener?.searchTagsBackButtonDidTap()
    }
    
    func cancelButtonDidTap(forNavigation isForNavigation: Bool) {
        listener?.searchTagsCancelButtonDidTap(forNavigation: isForNavigation)
    }
    
    func rowDidSelect(tag: Tag, shouldAddTag: Bool, forNavigation isForNavigation: Bool) {
        if shouldAddTag {
            let result = tagRepository.add(tag)
            switch result {
            case .success(_): NotificationCenter.post(named: NotificationName.Tag.didSucceedToAddTag)
            case .failure(_): NotificationCenter.post(named: NotificationName.didFailToProcessData)
            }
        }
        tagBySearchStream.update(with: tag)
        listener?.searchTagsRowDidSelect(forNavigation: isForNavigation)
    }
    
    func didRemove() {
        listener?.searchTagsDidRemove()
    }
    
    private func performFetch() {
        let fetchedResultsController = tagRepository.fetchedResultsController()
        try? fetchedResultsController.performFetch()
        guard let tagEntities = fetchedResultsController.fetchedObjects else { return }
        let tags = tagEntities.map { Tag(name: $0.name) }
        presenter.update(with: tags)
    }
}
