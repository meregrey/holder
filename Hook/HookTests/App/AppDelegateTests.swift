//
//  AppDelegateTests.swift
//  HookTests
//
//  Created by Yeojin Yoon on 2022/01/01.
//

import XCTest
@testable import Hook

class AppDelegateTests: XCTestCase {
    
    private var sut: AppDelegate!
    
    private var component: AppComponent!
    private var credentialRepository: CredentialRepositoryMock!
    private var keychainManager: KeychainManagerMock!
    
    private var loginStateStream: ReadOnlyStream<LoginState> { credentialRepository.loginStateStream }
    
    override func setUp() {
        super.setUp()
        
        keychainManager = KeychainManagerMock()
        credentialRepository = CredentialRepositoryMock(keychainManager: keychainManager)
        component = AppComponent(credentialRepository: credentialRepository)
        
        sut = AppDelegate(component: component)
    }
    
    func testApplicationDidFinishLaunchingWithOptions() {
        // given
        
        // when
        _ = sut.application(.shared, didFinishLaunchingWithOptions: nil)
        
        // then
        XCTAssertEqual(credentialRepository.verifyCallCount, 1)
        XCTAssertEqual(keychainManager.searchItemCallCount, 1)
    }
    
    func testApplicationDidBecomeActive() {
        // given
        
        // when
        sut.applicationDidBecomeActive(.shared)
        
        // then
        XCTAssertEqual(credentialRepository.verifyCallCount, 1)
        XCTAssertEqual(keychainManager.searchItemCallCount, 1)
    }
    
    func testDidSucceedLogin() {
        // given
        let credential = Credential(identifier: "identifier_0", name: "name_0")
        
        // when
        sut.didSucceedLogin(withCredential: credential)
        
        // then
        XCTAssertEqual(credentialRepository.saveCallCount, 1)
        XCTAssertEqual(keychainManager.addItemCallCount, 1)
        XCTAssertEqual(loginStateStream.value, .loggedIn(credential: credential))
    }
    
    func testDidSucceedLoginWithFailure() {
        // given
        let credential = Credential(identifier: "identifier_0", name: "name_0")
        credentialRepository.shouldSaveSucceed = false
        
        // when
        sut.didSucceedLogin(withCredential: credential)
        
        // then
        XCTAssertEqual(credentialRepository.saveCallCount, 1)
        XCTAssertEqual(keychainManager.addItemCallCount, 1)
        XCTAssertEqual(loginStateStream.value, .loggedOut)
    }
    
    func testDidRequestLogout() {
        // given
        
        // when
        sut.didRequestLogout()
        
        // then
        XCTAssertEqual(credentialRepository.deleteCallCount, 1)
        XCTAssertEqual(keychainManager.deleteItemCallCount, 1)
    }
}
