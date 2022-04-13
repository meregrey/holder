//
//  SearchInteractor.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol SearchRouting: ViewableRouting {
    func attachSearchBar()
    func attachRecentSearches()
    func attachRecentSearchesView()
    func detachRecentSearchesView()
    func attachBookmarkList()
    func detachBookmarkList()
    func attachBookmarkDetail(bookmarkEntity: BookmarkEntity)
    func detachBookmarkDetail(includingView isViewIncluded: Bool)
    func attachEnterBookmark(mode: EnterBookmarkMode)
    func detachEnterBookmark(includingView isViewIncluded: Bool)
    func attachSelectTags(existingSelectedTags: [Tag])
    func detachSelectTags()
    func attachSearchTags()
    func detachSearchTags()
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
}

protocol SearchListener: AnyObject {}

protocol SearchInteractorDependency {
    var searchTermStream: MutableStream<String> { get }
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener, AdaptivePresentationControllerDelegate {
    
    private let dependency: SearchInteractorDependency
    
    private var searchTermStream: MutableStream<String> { dependency.searchTermStream }
    
    let presentationProxy = AdaptivePresentationControllerDelegateProxy()
    
    weak var router: SearchRouting?
    weak var listener: SearchListener?
    
    init(presenter: SearchPresentable, dependency: SearchInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        self.presentationProxy.delegate = self
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachSearchBar()
        router?.attachRecentSearches()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachEnterBookmark(includingView: false)
    }
    
    // MARK: - SearchBar
    
    func searchBarDidSearch() {
        router?.detachRecentSearchesView()
        router?.attachBookmarkList()
    }
    
    func searchBarCancelButtonDidTap() {
        router?.detachBookmarkList()
        router?.attachRecentSearchesView()
    }
    
    // MARK: - RecentSearches
    
    func recentSearchesSearchTermDidSelect(searchTerm: String) {
        searchTermStream.update(with: searchTerm)
        router?.detachRecentSearchesView()
        router?.attachBookmarkList()
    }
    
    // MARK: - BookmarkList
    
    func bookmarkListBookmarkDidTap(bookmarkEntity: BookmarkEntity) {
        router?.attachBookmarkDetail(bookmarkEntity: bookmarkEntity)
    }
    
    func bookmarkListContextMenuEditDidTap(bookmark: Bookmark) {
        router?.attachEnterBookmark(mode: .edit(bookmark: bookmark))
    }
    
    // MARK: - BookmarkDetail
    
    func bookmarkDetailDidRemove() {
        router?.detachBookmarkDetail(includingView: false)
    }
    
    func bookmarkDetailBackwardButtonDidTap() {
        router?.detachBookmarkDetail(includingView: true)
    }
    
    func bookmarkDetailEditActionDidTap(bookmark: Bookmark) {
        router?.attachEnterBookmark(mode: .edit(bookmark: bookmark))
    }
    
    func bookmarkDetailDidRequestToDetach() {
        router?.detachBookmarkDetail(includingView: true)
    }
    
    // MARK: - EnterBookmark
    
    func enterBookmarkCloseButtonDidTap() {
        router?.detachEnterBookmark(includingView: true)
    }
    
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        router?.attachSelectTags(existingSelectedTags: existingSelectedTags)
    }
    
    func enterBookmarkSaveButtonDidTap() {
        router?.detachEnterBookmark(includingView: false)
    }
    
    // MARK: - SelectTags
    
    func selectTagsCloseButtonDidTap() {
        router?.detachSelectTags()
    }
    
    func selectTagsSearchBarDidTap() {
        router?.attachSearchTags()
    }
    
    func selectTagsDoneButtonDidTap() {
        router?.detachSelectTags()
    }
    
    // MARK: - SearchTags
    
    func searchTagsCancelButtonDidTap() {
        router?.detachSearchTags()
    }
    
    func searchTagsRowDidSelect() {
        router?.detachSearchTags()
    }
}
