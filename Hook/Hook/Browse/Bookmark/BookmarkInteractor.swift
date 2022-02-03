//
//  BookmarkInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/26.
//

import RIBs

protocol BookmarkRouting: Routing {
    func cleanupViews()
    func attachBookmarkBrowser()
    func attachEnterBookmark()
}

protocol BookmarkListener: AnyObject {}

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
}
