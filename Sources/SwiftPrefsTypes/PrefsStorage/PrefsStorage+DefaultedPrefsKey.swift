//
//  PrefsStorage+DefaultedPrefsKey.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// swiftformat:disable wrap

// MARK: - Get Value

extension PrefsStorage {
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Int {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == String {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Bool {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Double {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Float {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Data {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Date {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey, Element: PrefsStorageValue>(forKey key: Key) -> Key.Value where Key.StorageValue == [Element] {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey, Element: PrefsStorageValue>(forKey key: Key) -> Key.Value where Key.StorageValue == [String: Element] {
        key.decodeDefaulted(storageValue(forKey: key))
    }
}
