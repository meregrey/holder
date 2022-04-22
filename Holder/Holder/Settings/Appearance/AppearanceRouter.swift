//
//  AppearanceRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import RIBs

protocol AppearanceInteractable: Interactable {
    var router: AppearanceRouting? { get set }
    var listener: AppearanceListener? { get set }
}

protocol AppearanceViewControllable: ViewControllable {}

final class AppearanceRouter: ViewableRouter<AppearanceInteractable, AppearanceViewControllable>, AppearanceRouting {
    
    override init(interactor: AppearanceInteractable, viewController: AppearanceViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
