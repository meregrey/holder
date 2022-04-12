//
//  Cache.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/02.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    
    private let wrapped = NSCache<WrappedKey, WrappedValue>()
    
    func value(for key: Key) -> Value? {
        let wrappedValue = wrapped.object(forKey: WrappedKey(key))
        return wrappedValue?.value
    }
    
    func insert(_ value: Value, for key: Key) {
        wrapped.setObject(WrappedValue(value), forKey: WrappedKey(key))
    }
    
    func removeValue(for key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    func removeAllValues() {
        wrapped.removeAllObjects()
    }
    
    subscript(_ key: Key) -> Value? {
        get { value(for: key) }
        set {
            guard let value = newValue else {
                removeValue(for: key)
                return
            }
            insert(value, for: key)
        }
    }
}

private extension Cache {
    
    final class WrappedKey: NSObject {
        
        let key: Key
        
        override var hash: Int { key.hashValue }
        
        init(_ key: Key) { self.key = key }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let wrappedKey = object as? WrappedKey else { return false }
            return wrappedKey.key == key
        }
    }
    
    final class WrappedValue {
        
        let value: Value
        
        init(_ value: Value) { self.value = value }
    }
}
