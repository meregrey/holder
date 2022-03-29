//
//  FavoritesInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol FavoritesRouting: ViewableRouting {
    func attachSearchBar()
    func attachBookmarkList()
}

protocol FavoritesPresentable: Presentable {
    var listener: FavoritesPresentableListener? { get set }
}

protocol FavoritesListener: AnyObject {}

final class FavoritesInteractor: PresentableInteractor<FavoritesPresentable>, FavoritesInteractable, FavoritesPresentableListener {
    
    weak var router: FavoritesRouting?
    weak var listener: FavoritesListener?
    
    override init(presenter: FavoritesPresentable) {
        super.init(presenter: presenter)
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
    
    // MARK: - SearchBar
    
    func searchBarDidSearch() {}
    
    func searchBarCancelButtonDidTap() {}
    
    // MARK: - BookmarkList
    
    func bookmarkListBookmarkDidTap(bookmarkEntity: BookmarkEntity) {}
    
    func bookmarkListContextMenuEditDidTap(bookmark: Bookmark) {}
}
