//
//  SettingsRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsInteractable: Interactable, AppearanceListener {
    var router: SettingsRouting? { get set }
    var listener: SettingsListener? { get set }
}

protocol SettingsViewControllable: ViewControllable {
    func push(_ viewControllable: ViewControllable)
    func pop()
}

final class SettingsRouter: ViewableRouter<SettingsInteractable, SettingsViewControllable>, SettingsRouting {
    
    private let appearance: AppearanceBuildable
    
    private var appearanceRouter: AppearanceRouting?
    
    init(interactor: SettingsInteractable,
         viewController: SettingsViewControllable,
         appearance: AppearanceBuildable) {
        self.appearance = appearance
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAppearance() {
        guard appearanceRouter == nil else { return }
        let router = appearance.build(withListener: interactor)
        appearanceRouter = router
        attachChild(router)
        viewController.push(router.viewControllable)
    }
    
    func detachAppearance(includingView isViewIncluded: Bool) {
        guard let router = appearanceRouter else { return }
        if isViewIncluded { viewController.pop() }
        detachChild(router)
        appearanceRouter = nil
    }
}
