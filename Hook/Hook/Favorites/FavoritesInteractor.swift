//
//  FavoritesInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol FavoritesRouting: ViewableRouting {}

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
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
