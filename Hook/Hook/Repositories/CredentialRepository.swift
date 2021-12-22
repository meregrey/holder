//
//  CredentialRepository.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import Foundation

protocol CredentialRepositoryType {
    func save(_ credential: Credential) -> Result<Void, Error>
    func fetch() -> Result<Credential?, Error>
    func delete() -> Result<Void, Error>
}

final class CredentialRepository: CredentialRepositoryType {
    
    private let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
    private let keychainManager: KeychainManageable
    
    private var currentCredential: Credential?
    
    init(keychainManager: KeychainManageable) {
        self.keychainManager = keychainManager
    }
    
    func save(_ credential: Credential) -> Result<Void, Error> {
        do {
            let attributes = [kSecAttrService: bundleIdentifier, kSecAttrAccount: credential.name]
            try keychainManager.addItem(credential.identifier,
                                        itemClass: kSecClassGenericPassword,
                                        itemAttributes: attributes)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetch() -> Result<Credential?, Error> {
        guard currentCredential == nil else { return .success(currentCredential) }
        var item: KeychainItem<String>? = nil
        do {
            item = try keychainManager.searchItem(ofClass: kSecClassGenericPassword, itemAttributes: [kSecAttrService: bundleIdentifier])
        } catch {
            return .failure(error)
        }
        guard let item = item else { return .success(nil) }
        guard let name = item.account else { return .success(nil) }
        currentCredential = Credential(identifier: item.value, name: name)
        return .success(currentCredential)
    }
    
    func delete() -> Result<Void, Error> {
        guard let credential = currentCredential else { return .success(()) }
        do {
            let attributes = [kSecAttrService: bundleIdentifier, kSecAttrAccount: credential.name]
            try keychainManager.deleteItem(credential.identifier,
                                           itemClass: kSecClassGenericPassword,
                                           itemAttributes: attributes)
            currentCredential = nil
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
