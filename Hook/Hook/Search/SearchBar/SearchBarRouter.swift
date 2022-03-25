//
//  SearchBarRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import RIBs

protocol SearchBarInteractable: Interactable {
    var router: SearchBarRouting? { get set }
    var listener: SearchBarListener? { get set }
}

protocol SearchBarViewControllable: ViewControllable {}

final class SearchBarRouter: ViewableRouter<SearchBarInteractable, SearchBarViewControllable>, SearchBarRouting {
    
    override init(interactor: SearchBarInteractable, viewController: SearchBarViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
