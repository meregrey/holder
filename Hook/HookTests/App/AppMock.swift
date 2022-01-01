//
//  AppMock.swift
//  HookTests
//
//  Created by Yeojin Yoon on 2022/01/01.
//

import Foundation
@testable import Hook

final class CredentialRepositoryMock: CredentialRepositoryType {
    
    private let mutableLoginStateStream = MutableStream<LoginState>(initialValue: .loggedOut)
    private let keychainManager: KeychainManageable
    
    var loginStateStream: ReadOnlyStream<LoginState> { mutableLoginStateStream }
    
    var verifyCallCount = 0
    var saveCallCount = 0
    var deleteCallCount = 0
    
    var shouldSaveSucceed = true
    
    init(keychainManager: KeychainManageable) {
        self.keychainManager = keychainManager
    }
    
    func verify() {
        verifyCallCount += 1
        let _: KeychainItem<String>? = try? keychainManager.searchItem(ofClass: kSecClassGenericPassword, itemAttributes: [:])
    }
    
    func save(credential: Credential) -> Result<Void, Error> {
        saveCallCount += 1
        try? keychainManager.addItem("", itemClass: kSecClassGenericPassword, itemAttributes: [:])
        if shouldSaveSucceed {
            mutableLoginStateStream.update(withValue: .loggedIn(credential: credential))
            return .success(())
        } else {
            return .failure(NSError())
        }
    }
    
    func delete() {
        deleteCallCount += 1
        try? keychainManager.deleteItem(ofClass: kSecClassGenericPassword, itemAttributes: [:])
    }
}

final class KeychainManagerMock: KeychainManageable {
    
    var addItemCallCount = 0
    var searchItemCallCount = 0
    var deleteItemCallCount = 0
    
    func addItem<T: Convertible>(_ value: T, itemClass: CFString, itemAttributes: [CFString : Any]) throws {
        addItemCallCount += 1
    }
    
    func searchItem<T: Convertible>(ofClass itemClass: CFString, itemAttributes: [CFString : Any]) throws -> KeychainItem<T>? {
        searchItemCallCount += 1
        return nil
    }
    
    func deleteItem(ofClass itemClass: CFString, itemAttributes: [CFString : Any]) throws {
        deleteItemCallCount += 1
    }
}
