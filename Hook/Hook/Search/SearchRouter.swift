//
//  SearchRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol SearchInteractable: Interactable {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    
    override init(interactor: SearchInteractable, viewController: SearchViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
