//
//  RootInteractorTests.swift
//  HookTests
//
//  Created by Yeojin Yoon on 2021/12/31.
//

import XCTest
@testable import Hook

final class RootInteractorTests: XCTestCase {

    private var sut: RootInteractor!
    
    private var presenter: RootPresentableMock!
    private var dependency: RootInteractorDependencyMock!
    private var router: RootRoutingMock!
    private var listener: RootListenerMock!
    
    private var mutableLoginStateStream: MutableStream<LoginState> { dependency.mutableLoginStateStream }
    private var loginStateStream: ReadOnlyStream<LoginState> { dependency.loginStateStream }

    override func setUp() {
        super.setUp()
        
        presenter = RootPresentableMock()
        dependency = RootInteractorDependencyMock()
        router = RootRoutingMock()
        listener = RootListenerMock()
        
        sut = RootInteractor(presenter: presenter, dependency: dependency)
        sut.router = router
        sut.listener = listener
        
        presenter.listener = sut
    }
    
    func testDidBecomeActive() {
        // given
        let credential = Credential(identifier: "identifier_0", name: "name_0")
        mutableLoginStateStream.update(withValue: .loggedIn(credential: credential))
        
        // when
        sut.activate()
        
        // then
        XCTAssertEqual(router.routeToLoggedInCallCount, 1)
        XCTAssertEqual(router.credential?.identifier, credential.identifier)
        XCTAssertEqual(router.credential?.name, credential.name)
        XCTAssertEqual(loginStateStream.value, .loggedIn(credential: credential))
    }
    
    func testDidSucceedLogin() {
        // given
        let credential = Credential(identifier: "identifier_0", name: "name_0")
        
        // when
        sut.didSucceedLogin(withCredential: credential)
        
        // then
        XCTAssertEqual(listener.didSucceedLoginCallCount, 1)
        XCTAssertEqual(listener.credential?.identifier, credential.identifier)
        XCTAssertEqual(listener.credential?.name, credential.name)
    }
}
