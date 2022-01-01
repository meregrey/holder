//
//  RootMock.swift
//  HookTests
//
//  Created by Yeojin Yoon on 2021/12/31.
//

import Foundation
@testable import Hook

final class RootPresentableMock: RootPresentable {
    
    var listener: RootPresentableListener?
    
    var displayAlertCallCount = 0
    var displayAlertHandler: ((_ title: String, _ message: String) -> Void)?
    
    func displayAlert(withTitle title: String, message: String) {
        displayAlertCallCount += 1
        if let displayAlertHandler = displayAlertHandler { return displayAlertHandler(title, message) }
    }
}

final class RootInteractorDependencyMock: RootInteractorDependency {
    
    var mutableLoginStateStream: MutableStream<LoginState> = .init(initialValue: .loggedOut)
    var loginStateStream: ReadOnlyStream<LoginState> { mutableLoginStateStream }
}

final class RootRoutingMock: ViewableRoutingMock, RootRouting {
    
    var routeToLoggedOutCallCount = 0
    var routeToLoggedOutHandler: (() -> Void)?
    var routeToLoggedInCallCount = 0
    var routeToLoggedInHandler: ((_ credential: Credential) -> Void)?
    
    var credential: Credential?
    
    func routeToLoggedOut() {
        routeToLoggedOutCallCount += 1
        if let routeToLoggedOutHandler = routeToLoggedOutHandler { return routeToLoggedOutHandler() }
    }
    
    func routeToLoggedIn(withCredential credential: Credential) {
        routeToLoggedInCallCount += 1
        self.credential = credential
        if let routeToLoggedInHandler = routeToLoggedInHandler { return routeToLoggedInHandler(credential) }
    }
}

final class RootListenerMock: RootListener {
    
    var didSucceedLoginCallCount = 0
    var didSucceedLoginHandler: ((_ credential: Credential) -> Void)?
    var didRequestLogoutCallCount = 0
    var didRequestLogoutHandler: (() -> Void)?
    
    var credential: Credential?
    
    func didSucceedLogin(withCredential credential: Credential) {
        didSucceedLoginCallCount += 1
        self.credential = credential
        if let didSucceedLoginHandler = didSucceedLoginHandler { return didSucceedLoginHandler(credential) }
    }
    
    func didRequestLogout() {
        didRequestLogoutCallCount += 1
        if let didRequestLogoutHandler = didRequestLogoutHandler { return didRequestLogoutHandler() }
    }
}
