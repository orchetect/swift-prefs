//
//  UserDefaultsPrefsStorage.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// UserDefaults-backed ``PrefsStorage`` for use in ``PrefsSchema``.
open class UserDefaultsPrefsStorage {
    public let suite: UserDefaults
    
    public init(suite: UserDefaults = .standard) {
        self.suite = suite
    }
}

extension UserDefaultsPrefsStorage: @unchecked Sendable { }

extension UserDefaultsPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?) {
        suite.set(value, forKey: key)
    }
    
    public func setUnsafeStorageValue(forKey key: String, to value: Any?) {
        suite.set(value, forKey: key)
    }
    
    // MARK: - Get
    
    public func storageValue(forKey key: String) -> Int? {
        suite.integerOptional(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> String? {
        suite.string(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Bool? {
        suite.boolOptional(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Double? {
        suite.doubleOptional(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Float? {
        suite.floatOptional(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Data? {
        suite.data(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Date? {
        (suite.object(forKey: key) as? NSDate) as Date?
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        if let typedArray = rawArray as? [Element] {
            return typedArray
        } else if let typedArray = rawArray.map(UserDefaults.castAsPrefsStorageCompatible(value:)) as? [Element] {
            return typedArray
        } else {
            return nil
        }
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        if let typedDict = rawDict as? [String: Element] {
            return typedDict
        } else if let typedDict = rawDict.mapValues(UserDefaults.castAsPrefsStorageCompatible(value:)) as? [String: Element] {
            return typedDict
        } else {
            return nil
        }
    }
    
    public func unsafeStorageValue(forKey key: String) -> Any? {
        suite.object(forKey: key)
    }
}

// MARK: - Additional Storage Access Methods

extension UserDefaultsPrefsStorage {
    public func unsafeStorageValue(forKey key: String) -> [Any]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray
            .map(UserDefaults.castAsPrefsStorageCompatible(value:)) // TODO: may not be necessary
        return typedArray
    }
    
    public func unsafeStorageValue(forKey key: String) -> [String: Any]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict
            .mapValues(UserDefaults.castAsPrefsStorageCompatible(value:)) // TODO: may not be necessary
        return typedDict
    }
}
