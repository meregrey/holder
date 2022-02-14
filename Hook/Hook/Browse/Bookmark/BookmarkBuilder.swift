//
//  BookmarkBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/26.
//

import RIBs

protocol BookmarkDependency: Dependency {
    var baseViewController: BrowseViewControllable { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class BookmarkComponent: Component<BookmarkDependency>, BookmarkInteractorDependency, BookmarkBrowserDependency, EnterBookmarkDependency {
    
    fileprivate var baseViewController: BrowseViewControllable { dependency.baseViewController }
    
    let bookmarkRepository: BookmarkRepositoryType
    
    var bookmarksStream: ReadOnlyStream<[Tag: [Bookmark]]> { bookmarkRepository.bookmarksStream }
    var selectedTagsStream: ReadOnlyStream<[Tag]> { dependency.selectedTagsStream }
    
    init(dependency: BookmarkDependency, bookmarkRepository: BookmarkRepositoryType = BookmarkRepository()) {
        self.bookmarkRepository = bookmarkRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol BookmarkBuildable: Buildable {
    func build(withListener listener: BookmarkListener) -> BookmarkRouting
}

final class BookmarkBuilder: Builder<BookmarkDependency>, BookmarkBuildable {
    
    override init(dependency: BookmarkDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: BookmarkListener) -> BookmarkRouting {
        let component = BookmarkComponent(dependency: dependency)
        let interactor = BookmarkInteractor(dependency: component)
        interactor.listener = listener
        let bookmarkBrowser = BookmarkBrowserBuilder(dependency: component)
        let enterBookmark = EnterBookmarkBuilder(dependency: component)
        return BookmarkRouter(interactor: interactor,
                              baseViewController: component.baseViewController,
                              bookmarkBrowser: bookmarkBrowser,
                              enterBookmark: enterBookmark)
    }
}
