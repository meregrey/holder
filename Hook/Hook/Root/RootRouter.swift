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
    
    private var loggedOutRouter: Routing?
    private var loggedInRouter: Routing?
    
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
        DispatchQueue.main.async {
            self.detachLoggedOut()
            self.attachLoggedIn(withCredential: credential)
        }
    }
    
    private func attachLoggedOut() {
        guard loggedOutRouter == nil else { return }
        let router = loggedOut.build(withListener: interactor)
        loggedOutRouter = router
        attachChild(router)
        viewController.present(router.viewControllable)
    }
    
    private func detachLoggedOut() {
        guard let router = loggedOutRouter else { return }
        viewController.dismiss()
        detachChild(router)
        loggedOutRouter = nil
    }
    
    private func attachLoggedIn(withCredential credential: Credential) {
        guard loggedInRouter == nil else { return }
        let router = loggedIn.build(withListener: interactor, credential: credential)
        loggedInRouter = router
        attachChild(router)
        viewController.present(router.viewControllable)
    }
    
    private func detachLoggedIn() {
        guard let router = loggedInRouter else { return }
        viewController.dismiss()
        detachChild(router)
        loggedInRouter = nil
    }
}
