//
//  CredentialRepository.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import Foundation

protocol CredentialRepositoryType {
    func save(_ credential: Credential) throws
    func fetch() throws -> Credential?
    func delete() throws
}

final class CredentialRepository: CredentialRepositoryType {
    
    private let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
    private let keychainManager: KeychainManageable
    
    private var currentCredential: Credential?
    
    init(keychainManager: KeychainManageable) {
        self.keychainManager = keychainManager
    }
    
    func save(_ credential: Credential) throws {
        let attributes = [kSecAttrService: bundleIdentifier, kSecAttrAccount: credential.name]
        try keychainManager.addItem(credential.identifier,
                                    itemClass: kSecClassGenericPassword,
                                    itemAttributes: attributes)
    }
    
    func fetch() throws -> Credential? {
        guard currentCredential == nil else { return currentCredential }
        guard let item: KeychainItem<String> = try keychainManager.searchItem(ofClass: kSecClassGenericPassword,
                                                                              itemAttributes: [kSecAttrService: bundleIdentifier]) else { return nil }
        guard let name = item.account else { return nil }
        currentCredential = Credential(identifier: item.value, name: name)
        return currentCredential
    }
    
    func delete() throws {
        guard let credential = currentCredential else { return }
        let attributes = [kSecAttrService: bundleIdentifier, kSecAttrAccount: credential.name]
        try keychainManager.deleteItem(credential.identifier,
                                       itemClass: kSecClassGenericPassword,
                                       itemAttributes: attributes)
        currentCredential = nil
    }
}
