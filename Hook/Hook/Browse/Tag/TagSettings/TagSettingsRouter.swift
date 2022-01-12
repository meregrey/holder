//
//  TagSettingsRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import RIBs

protocol TagSettingsInteractable: Interactable {
    var router: TagSettingsRouting? { get set }
    var listener: TagSettingsListener? { get set }
}

protocol TagSettingsViewControllable: ViewControllable {}

final class TagSettingsRouter: ViewableRouter<TagSettingsInteractable, TagSettingsViewControllable>, TagSettingsRouting {
    
    override init(interactor: TagSettingsInteractable, viewController: TagSettingsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
