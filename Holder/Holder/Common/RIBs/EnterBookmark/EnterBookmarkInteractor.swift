//
//  EnterBookmarkInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import LinkPresentation
import RIBs

protocol EnterBookmarkRouting: ViewableRouting {}

protocol EnterBookmarkPresentable: Presentable {
    var listener: EnterBookmarkPresentableListener? { get set }
    func update(with selectedTags: [Tag])
    func dismiss()
}

protocol EnterBookmarkListener: AnyObject {
    func enterBookmarkCloseButtonDidTap()
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag])
    func enterBookmarkSaveButtonDidTap()
}

protocol EnterBookmarkInteractorDependency {
    var mode: EnterBookmarkMode { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class EnterBookmarkInteractor: PresentableInteractor<EnterBookmarkPresentable>, EnterBookmarkInteractable, EnterBookmarkPresentableListener {
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let dependency: EnterBookmarkInteractorDependency
    
    private var mode: EnterBookmarkMode { dependency.mode }
    private var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
    weak var router: EnterBookmarkRouting?
    weak var listener: EnterBookmarkListener?
    
    init(presenter: EnterBookmarkPresentable, dependency: EnterBookmarkInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeSelectedTagsStream()
        updateSelectedTagsStreamForEditMode()
    }
    
    override func willResignActive() {
        super.willResignActive()
        clearSelectedTagsStream()
    }
    
    func closeButtonDidTap() {
        listener?.enterBookmarkCloseButtonDidTap()
    }
    
    func tagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        listener?.enterBookmarkTagCollectionViewDidTap(existingSelectedTags: existingSelectedTags)
    }
    
    func saveButtonDidTapToAdd(bookmark: Bookmark) {
        presenter.dismiss()
        guard canContinueSaving(bookmark.url) else {
            listener?.enterBookmarkSaveButtonDidTap()
            return
        }
        addBookmark(bookmark)
    }
    
    func saveButtonDidTapToEdit(bookmark: Bookmark) {
        presenter.dismiss()
        updateBookmark(bookmark)
    }
    
    private func subscribeSelectedTagsStream() {
        selectedTagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
    
    private func updateSelectedTagsStreamForEditMode() {
        switch mode {
        case .add: return
        case .edit(let bookmark):
            guard let bookmarkTags = bookmark.tags else { return }
            let tags = bookmarkTags.sorted(by: { $0.index < $1.index }).map({ Tag(name: $0.name) })
            selectedTagsStream.update(with: tags)
        }
    }
    
    private func clearSelectedTagsStream() {
        selectedTagsStream.update(with: [])
    }
    
    private func canContinueSaving(_ url: URL) -> Bool {
        let result = bookmarkRepository.isExisting(url)
        switch result {
        case .success(let isExisting):
            if isExisting { NotificationCenter.post(named: NotificationName.Bookmark.existingBookmark) }
            return !isExisting
        case .failure(_):
            NotificationCenter.post(named: NotificationName.Store.didFailToCheck)
            return false
        }
    }
    
    private func addBookmark(_ bookmark: Bookmark) {
        LPMetadataProvider().startFetchingMetadata(for: bookmark.url) { metadata, _ in
            let bookmark = bookmark.updated(title: metadata?.title)
            let result = self.bookmarkRepository.add(with: bookmark)
            
            switch result {
            case .success(_): break
            case .failure(_): NotificationCenter.post(named: NotificationName.Store.didFailToSave)
            }
            
            self.listener?.enterBookmarkSaveButtonDidTap()
        }
    }
    
    private func updateBookmark(_ bookmark: Bookmark) {
        let result = bookmarkRepository.update(with: bookmark)
        switch result {
        case .success(_): break
        case .failure(_): NotificationCenter.post(named: NotificationName.Bookmark.didFailToUpdateBookmark)
        }
        listener?.enterBookmarkSaveButtonDidTap()
    }
}
