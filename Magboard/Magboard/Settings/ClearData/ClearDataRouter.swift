//
//  ClearDataRouter.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/04/06.
//

import RIBs

protocol ClearDataInteractable: Interactable {
    var router: ClearDataRouting? { get set }
    var listener: ClearDataListener? { get set }
}

protocol ClearDataViewControllable: ViewControllable {}

final class ClearDataRouter: ViewableRouter<ClearDataInteractable, ClearDataViewControllable>, ClearDataRouting {
    
    override init(interactor: ClearDataInteractable, viewController: ClearDataViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
