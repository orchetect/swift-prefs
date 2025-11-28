//
//  PrefsStorage+PrefsKey.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// swiftformat:disable wrap

// MARK: - Set Value

extension PrefsStorage {
    public func setValue<Key: PrefsKey>(forKey key: Key, to value: Key.Value?) {
        setStorageValue(forKey: key.key, to: key.encode(value))
    }
}

// MARK: - Get Storage Value

extension PrefsStorage {
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Int {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == String {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Bool {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Double {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Float {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Data {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Date {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey, Element: PrefsStorageValue>(forKey key: Key) -> [Element]? where Key.StorageValue == [Element]  {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey, Element: PrefsStorageValue>(forKey key: Key) -> [String: Element]? where Key.StorageValue == [String: Element] {
        storageValue(forKey: key.key)
    }
}

// MARK: - Get Value

extension PrefsStorage {
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Int {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == String {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Bool {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Double {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Float {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Data {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Date {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey, Element: PrefsStorageValue>(forKey key: Key) -> Key.Value? where Key.StorageValue == [Element] {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey, Element: PrefsStorageValue>(forKey key: Key) -> Key.Value? where Key.StorageValue == [String: Element] {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
}
