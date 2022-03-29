//
//  SearchBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol SearchDependency: Dependency {}

final class SearchComponent: Component<SearchDependency>, SearchInteractorDependency, SearchBarDependency, RecentSearchesDependency, BookmarkListDependency, BookmarkDetailDependency, EnterBookmarkDependency, SelectTagsDependency, SearchTagsDependency {
    
    let searchTermStream = MutableStream<String>(initialValue: "")
    let selectedTagsStream = MutableStream<[Tag]>(initialValue: [])
    let tagBySearchStream = MutableStream<Tag>(initialValue: Tag(name: ""))
    let isForFavorites = false
}

// MARK: - Builder

protocol SearchBuildable: Buildable {
    func build(withListener listener: SearchListener) -> SearchRouting
}

final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {

    override init(dependency: SearchDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchListener) -> SearchRouting {
        let component = SearchComponent(dependency: dependency)
        let viewController = SearchViewController()
        let interactor = SearchInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        let searchBar = SearchBarBuilder(dependency: component)
        let recentSearches = RecentSearchesBuilder(dependency: component)
        let bookmarkList = BookmarkListBuilder(dependency: component)
        let enterBookmark = EnterBookmarkBuilder(dependency: component)
        let selectTags = SelectTagsBuilder(dependency: component)
        let searchTags = SearchTagsBuilder(dependency: component)
        let bookmarkDetail = BookmarkDetailBuilder(dependency: component)
        return SearchRouter(interactor: interactor,
                            viewController: viewController,
                            searchBar: searchBar,
                            recentSearches: recentSearches,
                            bookmarkList: bookmarkList,
                            enterBookmark: enterBookmark,
                            selectTags: selectTags,
                            searchTags: searchTags,
                            bookmarkDetail: bookmarkDetail)
    }
}
