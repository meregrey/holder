//
//  SearchTagsInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/12.
//

import RIBs

protocol SearchTagsRouting: ViewableRouting {}

protocol SearchTagsPresentable: Presentable {
    var listener: SearchTagsPresentableListener? { get set }
}

protocol SearchTagsListener: AnyObject {
    func searchTagsCancelButtonDidTap()
    func searchTagsRowDidSelect()
}

protocol SearchTagsInteractorDependency {
    var tagBySearchStream: MutableStream<Tag> { get }
}

final class SearchTagsInteractor: PresentableInteractor<SearchTagsPresentable>, SearchTagsInteractable, SearchTagsPresentableListener {
    
    private let dependency: SearchTagsInteractorDependency
    
    private var tagBySearchStream: MutableStream<Tag> { dependency.tagBySearchStream }
    
    weak var router: SearchTagsRouting?
    weak var listener: SearchTagsListener?
    
    init(presenter: SearchTagsPresentable, dependency: SearchTagsInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func cancelButtonDidTap() {
        listener?.searchTagsCancelButtonDidTap()
    }
    
    func rowDidSelect(tag: Tag, shouldAddTag: Bool) {
        if shouldAddTag {
            let result = TagRepository.shared.add(tag)
            switch result {
            case .success(_): NotificationCenter.post(named: NotificationName.Tag.didSucceedToAddTag)
            case .failure(_): NotificationCenter.post(named: NotificationName.Tag.didFailToAddTag)
            }
        }
        tagBySearchStream.update(with: tag)
        listener?.searchTagsRowDidSelect()
    }
}
