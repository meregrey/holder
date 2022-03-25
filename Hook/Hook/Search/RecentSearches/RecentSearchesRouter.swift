//
//  RecentSearchesRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import RIBs

protocol RecentSearchesInteractable: Interactable {
    var router: RecentSearchesRouting? { get set }
    var listener: RecentSearchesListener? { get set }
}

protocol RecentSearchesViewControllable: ViewControllable {}

final class RecentSearchesRouter: ViewableRouter<RecentSearchesInteractable, RecentSearchesViewControllable>, RecentSearchesRouting {
    
    override init(interactor: RecentSearchesInteractable, viewController: RecentSearchesViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
