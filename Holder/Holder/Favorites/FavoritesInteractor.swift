//
//  FavoritesInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol FavoritesRouting: ViewableRouting {
    func attachSearchBar()
    func attachBookmarkList()
    func attachBookmarkDetail(bookmark: Bookmark)
    func detachBookmarkDetail(includingView isViewIncluded: Bool)
    func attachEnterBookmark(mode: EnterBookmarkMode, forNavigation isForNavigation: Bool)
    func detachEnterBookmark(includingView isViewIncluded: Bool, forNavigation isForNavigation: Bool)
    func attachSelectTags(existingSelectedTags: [Tag], forNavigation isForNavigation: Bool)
    func detachSelectTags(includingView isViewIncluded: Bool, forNavigation isForNavigation: Bool)
    func attachSearchTags(forNavigation isForNavigation: Bool)
    func detachSearchTags(includingView isViewIncluded: Bool, forNavigation isForNavigation: Bool)
}

protocol FavoritesPresentable: Presentable {
    var listener: FavoritesPresentableListener? { get set }
}

protocol FavoritesListener: AnyObject {}

final class FavoritesInteractor: PresentableInteractor<FavoritesPresentable>, FavoritesInteractable, FavoritesPresentableListener, AdaptivePresentationControllerDelegate {
    
    let presentationProxy = AdaptivePresentationControllerDelegateProxy()
    
    weak var router: FavoritesRouting?
    weak var listener: FavoritesListener?
    
    override init(presenter: FavoritesPresentable) {
        super.init(presenter: presenter)
        self.presentationProxy.delegate = self
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachSearchBar()
        router?.attachBookmarkList()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachEnterBookmark(includingView: false, forNavigation: false)
    }
    
    // MARK: - SearchBar
    
    func searchBarDidSearch() {}
    
    func searchBarCancelButtonDidTap() {}
    
    // MARK: - BookmarkList
    
    func bookmarkListBookmarkDidTap(bookmark: Bookmark) {
        router?.attachBookmarkDetail(bookmark: bookmark)
    }
    
    func bookmarkListContextMenuEditDidTap(bookmark: Bookmark) {
        router?.attachEnterBookmark(mode: .edit(bookmark), forNavigation: false)
    }
    
    // MARK: - BookmarkDetail
    
    func bookmarkDetailDidRemove() {
        router?.detachBookmarkDetail(includingView: false)
    }
    
    func bookmarkDetailEditActionDidTap(bookmark: Bookmark) {
        router?.attachEnterBookmark(mode: .edit(bookmark), forNavigation: true)
    }
    
    func bookmarkDetailBackwardButtonDidTap() {
        router?.detachBookmarkDetail(includingView: true)
    }
    
    func bookmarkDetailDidRequestToDetach() {
        router?.detachBookmarkDetail(includingView: true)
    }
    
    // MARK: - EnterBookmark
    
    func enterBookmarkCancelButtonDidTap() {
        router?.detachEnterBookmark(includingView: true, forNavigation: false)
    }
    
    func enterBookmarkBackButtonDidTap() {
        router?.detachEnterBookmark(includingView: true, forNavigation: true)
    }
    
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag], forNavigation isForNavigation: Bool) {
        router?.attachSelectTags(existingSelectedTags: existingSelectedTags, forNavigation: isForNavigation)
    }
    
    func enterBookmarkSaveButtonDidTap() {
        router?.detachEnterBookmark(includingView: false, forNavigation: false)
    }
    
    func enterBookmarkDidRemove() {
        router?.detachEnterBookmark(includingView: false, forNavigation: true)
    }
    
    // MARK: - SelectTags
    
    func selectTagsCancelButtonDidTap() {
        router?.detachSelectTags(includingView: true, forNavigation: false)
    }
    
    func selectTagsBackButtonDidTap() {
        router?.detachSelectTags(includingView: true, forNavigation: true)
    }
    
    func selectTagsSearchBarDidTap(forNavigation isForNavigation: Bool) {
        router?.attachSearchTags(forNavigation: isForNavigation)
    }
    
    func selectTagsDoneButtonDidTap(forNavigation isForNavigation: Bool) {
        router?.detachSelectTags(includingView: true, forNavigation: isForNavigation)
    }
    
    func selectTagsDidRemove() {
        router?.detachSelectTags(includingView: false, forNavigation: true)
    }
    
    // MARK: - SearchTags
    
    func searchTagsBackButtonDidTap() {
        router?.detachSearchTags(includingView: true, forNavigation: true)
    }
    
    func searchTagsCancelButtonDidTap(forNavigation isForNavigation: Bool) {
        router?.detachSearchTags(includingView: true, forNavigation: isForNavigation)
    }
    
    func searchTagsRowDidSelect(forNavigation isForNavigation: Bool) {
        router?.detachSearchTags(includingView: true, forNavigation: isForNavigation)
    }
    
    func searchTagsDidRemove() {
        router?.detachSearchTags(includingView: false, forNavigation: true)
    }
}
