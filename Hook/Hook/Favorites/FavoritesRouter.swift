//
//  FavoritesRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol FavoritesInteractable: Interactable {
    var router: FavoritesRouting? { get set }
    var listener: FavoritesListener? { get set }
}

protocol FavoritesViewControllable: ViewControllable {}

final class FavoritesRouter: ViewableRouter<FavoritesInteractable, FavoritesViewControllable>, FavoritesRouting {
    
    override init(interactor: FavoritesInteractable, viewController: FavoritesViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
