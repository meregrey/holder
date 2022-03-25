//
//  BookmarkBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/26.
//

import RIBs

protocol BookmarkDependency: Dependency {
    var currentTagStream: MutableStream<Tag> { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
    var baseViewController: BrowseViewControllable { get }
}

final class BookmarkComponent: Component<BookmarkDependency>, BookmarkBrowserDependency, EnterBookmarkDependency, BookmarkDetailDependency {
    
    var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
    var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    var baseViewController: BrowseViewControllable { dependency.baseViewController }
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
        let interactor = BookmarkInteractor()
        interactor.listener = listener
        let bookmarkBrowser = BookmarkBrowserBuilder(dependency: component)
        let enterBookmark = EnterBookmarkBuilder(dependency: component)
        let bookmarkDetail = BookmarkDetailBuilder(dependency: component)
        return BookmarkRouter(interactor: interactor,
                              baseViewController: component.baseViewController,
                              bookmarkBrowser: bookmarkBrowser,
                              enterBookmark: enterBookmark,
                              bookmarkDetail: bookmarkDetail)
    }
}
