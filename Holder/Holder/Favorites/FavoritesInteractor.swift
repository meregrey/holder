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
    func attachBookmarkDetail(bookmarkEntity: BookmarkEntity)
    func detachBookmarkDetail(includingView isViewIncluded: Bool)
    func attachEnterBookmark(mode: EnterBookmarkMode)
    func detachEnterBookmark(includingView isViewIncluded: Bool)
    func attachSelectTags(existingSelectedTags: [Tag])
    func detachSelectTags()
    func attachSearchTags()
    func detachSearchTags()
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
        router?.detachEnterBookmark(includingView: false)
    }
    
    // MARK: - SearchBar
    
    func searchBarDidSearch() {}
    
    func searchBarCancelButtonDidTap() {}
    
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
