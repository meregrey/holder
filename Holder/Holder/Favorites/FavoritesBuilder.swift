//
//  FavoritesBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol FavoritesDependency: Dependency {}

final class FavoritesComponent: Component<FavoritesDependency>, SearchBarDependency, BookmarkListDependency, BookmarkDetailDependency, EnterBookmarkDependency, SelectTagsDependency, SearchTagsDependency {
    
    let searchTermStream = MutableStream<String>(initialValue: "")
    let selectedTagsStream = MutableStream<[Tag]>(initialValue: [])
    let tagBySearchStream = MutableStream<Tag>(initialValue: Tag(name: ""))
    let isForFavorites = true
}

// MARK: - Builder

protocol FavoritesBuildable: Buildable {
    func build(withListener listener: FavoritesListener) -> FavoritesRouting
}

final class FavoritesBuilder: Builder<FavoritesDependency>, FavoritesBuildable {
    
    override init(dependency: FavoritesDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: FavoritesListener) -> FavoritesRouting {
        let component = FavoritesComponent(dependency: dependency)
        let viewController = FavoritesViewController()
        let interactor = FavoritesInteractor(presenter: viewController)
        interactor.listener = listener
        let searchBar = SearchBarBuilder(dependency: component)
        let bookmarkList = BookmarkListBuilder(dependency: component)
        let bookmarkDetail = BookmarkDetailBuilder(dependency: component)
        let enterBookmark = EnterBookmarkBuilder(dependency: component)
        let selectTags = SelectTagsBuilder(dependency: component)
        let searchTags = SearchTagsBuilder(dependency: component)
        return FavoritesRouter(interactor: interactor,
                               viewController: viewController,
                               searchBar: searchBar,
                               bookmarkList: bookmarkList,
                               bookmarkDetail: bookmarkDetail,
                               enterBookmark: enterBookmark,
                               selectTags: selectTags,
                               searchTags: searchTags)
    }
}
