//
//  PrefsStorage+PrefsCodable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// swiftformat:disable wrap

// MARK: - Set Value

extension PrefsStorage {
    public func setValue<Coding: PrefsCodable>(forKey key: String, to value: Coding.Value?, using coding: Coding) {
        let encoded = value != nil ? coding.encode(prefsValue: value!) : nil
        setStorageValue(forKey: key, to: encoded)
    }
}

// MARK: - Get Storage Value

extension PrefsStorage {
    public func storageValue<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == Int {
        storageValue(forKey: key)
    }
    
    public func storageValue<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == String {
        storageValue(forKey: key)
    }
    
    public func storageValue<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == Bool {
        storageValue(forKey: key)
    }
    
    public func storageValue<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == Double {
        storageValue(forKey: key)
    }
    
    public func storageValue<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == Float {
        storageValue(forKey: key)
    }
    
    public func storageValue<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == Data {
        storageValue(forKey: key)
    }
    
    public func storageValue<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == Date {
        storageValue(forKey: key)
    }
    
    public func storageValue<Coding: PrefsCodable, Element: PrefsStorageValue>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == [Element] {
        storageValue(forKey: key)
    }
    
    public func storageValue<Coding: PrefsCodable, Element: PrefsStorageValue>(forKey key: String, using coding: Coding) -> Coding.StorageValue? where Coding.StorageValue == [String: Element] {
        storageValue(forKey: key)
    }
}

// MARK: - Get Value

extension PrefsStorage {
    public func value<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == Int {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
    
    public func value<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == String {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
    
    public func value<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == Bool {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
    
    public func value<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == Double {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
    
    public func value<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == Float {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
    
    public func value<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == Data {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
    
    public func value<Coding: PrefsCodable>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == Date {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
    
    public func value<Coding: PrefsCodable, Element: PrefsStorageValue>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == [Element] {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
    
    public func value<Coding: PrefsCodable, Element: PrefsStorageValue>(forKey key: String, using coding: Coding) -> Coding.Value? where Coding.StorageValue == [String: Element] {
        guard let storageValue = storageValue(forKey: key, using: coding) else { return nil }
        return coding.decode(prefsValue: storageValue)
    }
}
