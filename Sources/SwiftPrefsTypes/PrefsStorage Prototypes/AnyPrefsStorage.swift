//
//  AnyPrefsStorage.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased box containing an instance of a concrete class conforming to ``PrefsStorage``.
public final class AnyPrefsStorage: PrefsStorage {
    public let wrapped: any PrefsStorage
    
    public init(_ wrapped: any PrefsStorage) {
        self.wrapped = wrapped
    }
}

extension AnyPrefsStorage {
    // MARK: - Set
    
    public func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?) {
        wrapped.setStorageValue(forKey: key, to: value)
    }
    
    public func setUnsafeStorageValue(forKey key: String, to value: Any?) {
        wrapped.setUnsafeStorageValue(forKey: key, to: value)
    }
    
    // MARK: - Get
    
    public func storageValue(forKey key: String) -> Int? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> String? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Bool? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Double? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Float? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Data? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Date? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        wrapped.storageValue(forKey: key)
    }
    
    public func unsafeStorageValue(forKey key: String) -> Any? {
        wrapped.unsafeStorageValue(forKey: key)
    }
}
