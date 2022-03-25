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
    
    private let tagsStream = TagRepository.shared.tagsStream
    
    weak var router: EditTagsRouting?
    weak var listener: EditTagsListener?
    
    override init(presenter: EditTagsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeTagsStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func backButtonDidTap() {
        listener?.editTagsBackButtonDidTap()
    }
    
    func saveButtonDidTap(remainingTags: [Tag], deletedTags: [Tag]) {
        let result = TagRepository.shared.update(tags: remainingTags)
        switch result {
        case .success(_): if deletedTags.count > 0 { deleteBookmarkTags(for: deletedTags) }
        case .failure(_): NotificationCenter.post(named: NotificationName.Tag.didFailToUpdateTags)
        }
        listener?.editTagsSaveButtonDidTap()
    }
    
    func didRemove() {
        listener?.editTagsDidRemove()
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
    
    private func deleteBookmarkTags(for tags: [Tag]) {
        tags.forEach { BookmarkRepository.shared.deleteTags(for: $0) }
    }
}
