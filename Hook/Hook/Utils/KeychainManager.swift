//
//  KeychainManager.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import Foundation

protocol KeychainManageable {
    func addItem<T: Encodable>(_ value: T,
                               itemClass: CFString,
                               itemAttributes: [CFString: Any]) throws
    
    func searchItem<T: Decodable>(ofClass itemClass: CFString,
                                  itemAttributes: [CFString: Any]) throws -> KeychainItem<T>?
    
    func deleteItem<T: Encodable>(_ value: T,
                                  itemClass: CFString,
                                  itemAttributes: [CFString: Any]) throws
}

final class KeychainManager: KeychainManageable {
    
    func addItem<T: Encodable>(_ value: T,
                               itemClass: CFString,
                               itemAttributes: [CFString: Any]) throws {
        guard let data = try? JSONEncoder().encode(value) else { throw KeychainError.failedToEncode }
        var query: [CFString: Any] = [kSecClass: itemClass, kSecValueData: data]
        itemAttributes.forEach { query[$0.key] = $0.value }
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    func searchItem<T: Decodable>(ofClass itemClass: CFString,
                                  itemAttributes: [CFString: Any]) throws -> KeychainItem<T>? {
        var query: [CFString: Any] = [kSecClass: itemClass,
                                      kSecMatchLimit: kSecMatchLimitOne,
                                      kSecReturnData: true,
                                      kSecReturnAttributes: true]
        itemAttributes.forEach { query[$0.key] = $0.value }
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        return try makeKeychainItem(with: item)
    }
    
    func deleteItem<T: Encodable>(_ value: T,
                                  itemClass: CFString,
                                  itemAttributes: [CFString: Any]) throws {
        guard let data = try? JSONEncoder().encode(value) else { throw KeychainError.failedToEncode }
        var query: [CFString: Any] = [kSecClass: itemClass, kSecValueData: data]
        itemAttributes.forEach { query[$0.key] = $0.value }
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    private func makeKeychainItem<T: Decodable>(with object: CFTypeRef?) throws -> KeychainItem<T> {
        guard let data = object.flatMap({ $0 as? [CFString: Any] })
                               .flatMap({ $0[kSecValueData] as? Data }) else { throw KeychainError.invalidData }
        guard let value = try? JSONDecoder().decode(T.self, from: data) else { throw KeychainError.failedToDecode }
        let account = object.flatMap({ $0 as? [CFString: Any] })
                            .flatMap({ $0[kSecAttrAccount] as? String })
        return KeychainItem(value: value, account: account)
    }
}
