//
//  TagBarInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import CoreData
import RIBs

protocol TagBarRouting: ViewableRouting {}

protocol TagBarPresentable: Presentable {
    var listener: TagBarPresentableListener? { get set }
    func update(with fetchedResultsController: NSFetchedResultsController<TagEntity>)
    func update(with currentTag: Tag)
}

protocol TagBarListener: AnyObject {
    func tagBarTagSettingsButtonDidTap()
}

protocol TagBarInteractorDependency {
    var currentTagStream: MutableStream<Tag> { get }
}

final class TagBarInteractor: PresentableInteractor<TagBarPresentable>, TagBarInteractable, TagBarPresentableListener {
    
    private let dependency: TagBarInteractorDependency
    
    private var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
    
    weak var router: TagBarRouting?
    weak var listener: TagBarListener?
    
    init(presenter: TagBarPresentable, dependency: TagBarInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        performFetch()
        subscribeCurrentTagStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func tagDidSelect(tag: Tag) {
        currentTagStream.update(with: tag)
    }
    
    func tagSettingsButtonDidTap() {
        listener?.tagBarTagSettingsButtonDidTap()
    }
    
    func tagDidChange() {
        NotificationCenter.post(named: NotificationName.Tag.didChange)
    }
    
    private func performFetch() {
        let fetchedResultsController = TagRepository.shared.fetchedResultsController()
        try? fetchedResultsController.performFetch()
        presenter.update(with: fetchedResultsController)
    }
    
    private func subscribeCurrentTagStream() {
        currentTagStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            guard $0.name.count > 0 else { return }
            self?.presenter.update(with: $0)
        }
    }
}
