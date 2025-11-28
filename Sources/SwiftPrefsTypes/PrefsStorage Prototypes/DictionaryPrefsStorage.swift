//
//  DictionaryPrefsStorage.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Dictionary-backed ``PrefsStorage`` for use in ``PrefsSchema`` with internally-synchronized local access.
///
/// This class may be used as-is, or subclassed to add additional functionality to dictionary-backed storage as an
/// alternative to implementing a custom ``PrefsStorage`` type.
open class DictionaryPrefsStorage: PrefsStorageInitializable {
    @SynchronizedLock
    var storage: [String: Any]
    
    /// Initialize from type-safe dictionary content.
    public init(root: [String: any PrefsStorageValue] = [:]) {
        storage = root
    }
    
    /// Initialize from raw untyped dictionary content.
    /// You are responsible for ensuring value types are compatible with related methods such as plist conversion.
    public required init(unsafe storage: [String: Any]) {
        self.storage = storage
    }
    
    // MARK: PrefsStorageInitializable inits
    
    // Note:
    //
    // `PrefsStorageInitializable` conformance is in class definition, as
    // `open class` requires protocol-required inits to be defined there and not in an extension.
    //
    
    required public convenience init<Format: PrefsStorageImportFormat>(
        from url: URL,
        format: Format
    ) throws where Format: PrefsStorageImportFormatFileImportable {
        self.init()
        try load(from: url, format: format, by: .reinitializing)
    }
    
    required public convenience init<Format: PrefsStorageImportFormat>(
        from data: Data,
        format: Format
    ) throws where Format: PrefsStorageImportFormatDataImportable {
        self.init()
        try load(from: data, format: format, by: .reinitializing)
    }
    
    required public convenience init<Format: PrefsStorageImportFormat>(
        from string: String,
        format: Format
    ) throws where Format: PrefsStorageImportFormatStringImportable {
        self.init()
        try load(from: string, format: format, by: .reinitializing)
    }
}

extension DictionaryPrefsStorage: @unchecked Sendable { }

extension DictionaryPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?) {
        storage[key] = value
    }
    
    public func setUnsafeStorageValue(forKey key: String, to value: Any?) {
        storage[key] = value
    }
    
    // MARK: - Get
    
    public func storageValue(forKey key: String) -> Int? {
        storage[key] as? Int
    }
    
    public func storageValue(forKey key: String) -> String? {
        storage[key] as? String
    }
    
    public func storageValue(forKey key: String) -> Bool? {
        storage[key] as? Bool
    }
    
    public func storageValue(forKey key: String) -> Double? {
        storage[key] as? Double
    }
    
    public func storageValue(forKey key: String) -> Float? {
        storage[key] as? Float
    }
    
    public func storageValue(forKey key: String) -> Data? {
        storage[key] as? Data
    }
    
    public func storageValue(forKey key: String) -> Date? {
        storage[key] as? Date
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        storage[key] as? [Element]
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        storage[key] as? [String: Element]
    }
    
    public func unsafeStorageValue(forKey key: String) -> Any? {
        storage[key]
    }
}
