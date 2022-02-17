//
//  BookmarkInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/26.
//

import LinkPresentation
import RIBs

protocol BookmarkRouting: Routing {
    func cleanupViews()
    func attachBookmarkBrowser()
    func attachEnterBookmark()
    func detachEnterBookmark()
}

protocol BookmarkListener: AnyObject {
    func attachSelectTags(existingSelectedTags: [Tag])
}

protocol BookmarkInteractorDependency {
    var bookmarkRepository: BookmarkRepositoryType { get }
}

final class BookmarkInteractor: Interactor, BookmarkInteractable {
    
    private let dependency: BookmarkInteractorDependency
    
    private var bookmarkRepository: BookmarkRepositoryType { dependency.bookmarkRepository }
    
    weak var router: BookmarkRouting?
    weak var listener: BookmarkListener?
    
    init(dependency: BookmarkInteractorDependency) {
        self.dependency = dependency
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachBookmarkBrowser()
    }
    
    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
    
    // MARK: - BookmarkBrowser
    
    func bookmarkBrowserAddBookmarkButtonDidTap() {
        router?.attachEnterBookmark()
    }
    
    // MARK: - EnterBookmark
    
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        listener?.attachSelectTags(existingSelectedTags: existingSelectedTags)
    }
    
    func enterBookmarkSaveButtonDidTap(url: URL, tags: [Tag]?, note: String?) {
        router?.detachEnterBookmark()
        LPMetadataProvider().startFetchingMetadata(for: url) { metadata, error in
            let bookmarkTags = tags?.enumerated().map { BookmarkTag(name: $1.name, index: $0) }
            let bookmark = Bookmark(url: url,
                                    isFavorite: false,
                                    tags: bookmarkTags,
                                    note: note,
                                    title: metadata?.title,
                                    host: url.host)
            self.bookmarkRepository.add(bookmark: bookmark)
        }
    }
}
