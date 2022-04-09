//
//  EditTagsInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/15.
//

import RIBs

protocol EditTagsRouting: ViewableRouting {}

protocol EditTagsPresentable: Presentable {
    var listener: EditTagsPresentableListener? { get set }
    func update(with tags: [Tag])
}

protocol EditTagsListener: AnyObject {
    func editTagsBackButtonDidTap()
    func editTagsSaveButtonDidTap()
    func editTagsDidRemove()
}

final class EditTagsInteractor: PresentableInteractor<EditTagsPresentable>, EditTagsInteractable, EditTagsPresentableListener {
    
    private let tagRepository = TagRepository.shared
    
    weak var router: EditTagsRouting?
    weak var listener: EditTagsListener?
    
    override init(presenter: EditTagsPresentable) {
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
        listener?.editTagsBackButtonDidTap()
    }
    
    func saveButtonDidTap(deletedTags: [Tag], remainingTags: [Tag]) {
        deleteTags(deletedTags)
        updateTags(remainingTags)
        listener?.editTagsSaveButtonDidTap()
    }
    
    func didRemove() {
        listener?.editTagsDidRemove()
    }
    
    private func performFetch() {
        let fetchedResultsController = tagRepository.fetchedResultsController()
        try? fetchedResultsController.performFetch()
        guard let tagEntities = fetchedResultsController.fetchedObjects else { return }
        let tags = tagEntities.map { Tag(name: $0.name) }
        presenter.update(with: tags)
    }
    
    private func deleteTags(_ tags: [Tag]) {
        guard tags.count > 0 else { return }
        let result = tagRepository.delete(tags)
        switch result {
        case .success(_): deleteBookmarkTags(for: tags)
        case .failure(_): NotificationCenter.post(named: NotificationName.Tag.didFailToDeleteTags)
        }
    }
    
    private func deleteBookmarkTags(for tags: [Tag]) {
        tags.forEach { BookmarkRepository.shared.deleteTags(for: $0) }
    }
    
    private func updateTags(_ tags: [Tag]) {
        let result = tagRepository.update(tags)
        switch result {
        case .success(_): break
        case .failure(_): NotificationCenter.post(named: NotificationName.Tag.didFailToUpdateTags)
        }
    }
}
