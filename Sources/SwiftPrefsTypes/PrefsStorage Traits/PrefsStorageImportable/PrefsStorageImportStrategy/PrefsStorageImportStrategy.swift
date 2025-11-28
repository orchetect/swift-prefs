//
//  PrefsStorageImportStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Import strategy used by prefs import formats.
public protocol PrefsStorageImportStrategy {
    /// The main method used to prepare imported data for merging into local storage.
    func prepareForImport(storage: [String: Any]) throws -> [String: Any]
}
