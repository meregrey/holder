//
//  RootInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func routeToLoggedOut()
    func routeToLoggedIn(withCredential credential: Credential)
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    func displayAlert(withTitle title: String, message: String)
}

protocol RootListener: AnyObject {
    func didSucceedLogin(withCredential credential: Credential)
    func didRequestLogout()
}

protocol RootInteractorDependency {
    var loginStateStream: ReadOnlyStream<LoginState> { get }
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {
    
    private let dependency: RootInteractorDependency
    
    private var loginStateStream: ReadOnlyStream<LoginState> { dependency.loginStateStream }

    weak var router: RootRouting?
    weak var listener: RootListener?
    
    init(presenter: RootPresentable, dependency: RootInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeLoginStateStream()
        registerToReceiveNotification()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didSucceedLogin(withCredential credential: Credential) {
        listener?.didSucceedLogin(withCredential: credential)
    }
    
    private func subscribeLoginStateStream() {
        loginStateStream.subscribe(disposedOnDeactivate: self) {
            self.determineToRoute(withLoginState: $0)
        }
    }

    private func determineToRoute(withLoginState loginState: LoginState) {
        switch loginState {
        case .loggedOut: router?.routeToLoggedOut()
        case .loggedIn(let credential): router?.routeToLoggedIn(withCredential: credential)
        }
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFailToSaveCredential),
                                               name: NotificationName.didFailToSaveCredential,
                                               object: nil)
    }

    @objc private func didFailToSaveCredential() {
        presenter.displayAlert(withTitle: LocalizedString.AlertTitle.keychainErrorOccured,
                               message: LocalizedString.AlertMessage.keychainErrorOccuredWhileSaving)
    }
}
