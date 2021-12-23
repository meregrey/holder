//
//  RootRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener, LoggedInListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    private let loggedOut: LoggedOutBuildable
    private let loggedIn: LoggedInBuildable
    
    private var loggedOutRouting: LoggedOutRouting?
    private var loggedInRouting: LoggedInRouting?
    
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         loggedOut: LoggedOutBuildable,
         loggedIn: LoggedInBuildable) {
        self.loggedOut = loggedOut
        self.loggedIn = loggedIn
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToLoggedOut() {
        detachLoggedIn()
        attachLoggedOut()
    }
    
    func routeToLoggedIn(withCredential credential: Credential) {
        detachLoggedOut()
        attachLoggedIn(withCredential: credential)
    }
    
    private func attachLoggedOut() {
        guard loggedOutRouting == nil else { return }
        let router = loggedOut.build(withListener: interactor)
        loggedOutRouting = router
        attachChild(router)
        viewController.present(router.viewControllable)
    }
    
    private func detachLoggedOut() {
        guard let router = loggedOutRouting else { return }
        viewController.dismiss()
        detachChild(router)
        loggedOutRouting = nil
    }
    
    private func attachLoggedIn(withCredential credential: Credential) {
        guard loggedInRouting == nil else { return }
        let router = loggedIn.build(withListener: interactor, credential: credential)
        loggedInRouting = router
        attachChild(router)
    }
    
    private func detachLoggedIn() {
        guard let router = loggedInRouting else { return }
        detachChild(router)
        loggedInRouting = nil
    }
}
