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
    func displayAlert(title: String)
    func dismiss()
    func pop()
}

protocol EnterBookmarkListener: AnyObject {
    func enterBookmarkCancelButtonDidTap()
    func enterBookmarkBackButtonDidTap()
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag], forNavigation isForNavigation: Bool)
    func enterBookmarkSaveButtonDidTap()
    func enterBookmarkDidRemove()
}

protocol EnterBookmarkInteractorDependency {
    var mode: EnterBookmarkMode { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class EnterBookmarkInteractor: PresentableInteractor<EnterBookmarkPresentable>, EnterBookmarkInteractable, EnterBookmarkPresentableListener {
    
    weak var router: EnterBookmarkRouting?
    weak var listener: EnterBookmarkListener?
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let dependency: EnterBookmarkInteractorDependency
    
    private var mode: EnterBookmarkMode { dependency.mode }
    private var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
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
    
    func cancelButtonDidTap() {
        listener?.enterBookmarkCancelButtonDidTap()
    }
    
    func backButtonDidTap() {
        listener?.enterBookmarkBackButtonDidTap()
    }
    
    func tagCollectionViewDidTap(existingSelectedTags: [Tag], forNavigation isForNavigation: Bool) {
        listener?.enterBookmarkTagCollectionViewDidTap(existingSelectedTags: existingSelectedTags, forNavigation: isForNavigation)
    }
    
    func saveButtonDidTapToAdd(bookmark: Bookmark) {
        guard canContinueSaving(bookmark.url) else { return }
        presenter.dismiss()
        addBookmark(bookmark)
    }
    
    func saveButtonDidTapToEdit(bookmark: Bookmark, forNavigation isForNavigation: Bool) {
        isForNavigation ? presenter.pop() : presenter.dismiss()
        updateBookmark(bookmark)
    }
    
    func didRemove() {
        listener?.enterBookmarkDidRemove()
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
    
    private func canContinueSaving(_ url: URL) -> Bool {
        let result = bookmarkRepository.isExisting(url)
        switch result {
        case .success(let isExisting):
            if isExisting { presenter.displayAlert(title: LocalizedString.AlertTitle.alreadySavedBookmark) }
            return !isExisting
        case .failure(_):
            NotificationCenter.post(named: NotificationName.Store.didFailToCheckStore)
            return false
        }
    }
    
    private func addBookmark(_ bookmark: Bookmark) {
        LPMetadataProvider().startFetchingMetadata(for: bookmark.url) { metadata, _ in
            let bookmark = bookmark.updated(title: metadata?.title)
            let result = self.bookmarkRepository.add(bookmark: bookmark)
            
            switch result {
            case .success(_): break
            case .failure(_): NotificationCenter.post(named: NotificationName.Store.didFailToSaveStore)
            }
            
            self.listener?.enterBookmarkSaveButtonDidTap()
        }
    }
    
    private func updateBookmark(_ bookmark: Bookmark) {
        let result = bookmarkRepository.update(bookmark: bookmark)
        switch result {
        case .success(_): NotificationCenter.post(named: NotificationName.Bookmark.didSucceedToUpdateBookmark, userInfo: [Notification.UserInfoKey.bookmark: bookmark])
        case .failure(_): NotificationCenter.post(named: NotificationName.didFailToProcessData)
        }
        listener?.enterBookmarkSaveButtonDidTap()
    }
    
    private func clearSelectedTagsStream() {
        selectedTagsStream.update(with: [])
    }
}
