//
//  PrefsStorage+Static.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PrefsStorage where Self == DictionaryPrefsStorage {
    /// Dictionary prefs storage.
    public static var dictionary: DictionaryPrefsStorage {
        DictionaryPrefsStorage()
    }

    /// Dictionary prefs storage with initial root content.
    public static func dictionary(root: [String: any PrefsStorageValue]) -> DictionaryPrefsStorage {
        DictionaryPrefsStorage(root: root)
    }

    /// Dictionary prefs storage with initial raw untyped root content.
    /// You are responsible for ensuring value types are compatible with related methods such as plist conversion.
    public static func dictionary(unsafe storage: [String: Any]) -> DictionaryPrefsStorage {
        DictionaryPrefsStorage(unsafe: storage)
    }

    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(
        from url: URL,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatFileImportable
    ) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(from: url, format: format)
    }

    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(
        from data: Data,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatDataImportable
    ) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(from: data, format: format)
    }

    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(
        from string: String,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatStringImportable
    ) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(from: string, format: format)
    }
}

extension PrefsStorage where Self == UserDefaultsPrefsStorage {
    /// Standard `UserDefaults` suite prefs storage.
    public static var userDefaults: UserDefaultsPrefsStorage {
        UserDefaultsPrefsStorage()
    }

    /// Custom `UserDefaults` suite prefs storage.
    public static func userDefaults(suite: UserDefaults) -> UserDefaultsPrefsStorage {
        UserDefaultsPrefsStorage(suite: suite)
    }
}
