//
//  EnterBookmarkInteractor.swift
//  Hook
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
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class EnterBookmarkInteractor: PresentableInteractor<EnterBookmarkPresentable>, EnterBookmarkInteractable, EnterBookmarkPresentableListener {
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let dependency: EnterBookmarkInteractorDependency
    
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
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func closeButtonDidTap() {
        listener?.enterBookmarkCloseButtonDidTap()
        clearSelectedTagsStream()
    }
    
    func tagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        listener?.enterBookmarkTagCollectionViewDidTap(existingSelectedTags: existingSelectedTags)
    }
    
    func saveButtonDidTap(url: URL, tags: [Tag]?, note: String?) {
        presenter.dismiss()
        clearSelectedTagsStream()
        guard canContinueSaving(url) else {
            listener?.enterBookmarkSaveButtonDidTap()
            return
        }
        attemptToSave(url: url, tags: tags, note: note)
    }
    
    private func subscribeSelectedTagsStream() {
        selectedTagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
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
    
    private func attemptToSave(url: URL, tags: [Tag]?, note: String?) {
        LPMetadataProvider().startFetchingMetadata(for: url) { metadata, error in
            guard error == nil else {
                NotificationCenter.post(named: NotificationName.Metadata.didFailToFetch)
                return
            }
            
            let bookmark = Bookmark(url: url, tags: tags, note: note, title: metadata?.title)
            let result = self.bookmarkRepository.add(bookmark)
            
            switch result {
            case .success(_): break
            case .failure(_): NotificationCenter.post(named: NotificationName.Store.didFailToSave)
            }
            
            self.listener?.enterBookmarkSaveButtonDidTap()
        }
    }
}
