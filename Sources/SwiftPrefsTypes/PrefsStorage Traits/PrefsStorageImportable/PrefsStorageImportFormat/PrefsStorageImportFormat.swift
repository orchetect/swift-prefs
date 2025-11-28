//
//  PrefsStorageImportFormat.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol that allows creating a type that implements storage content importing from a particular data serialization
/// format.
public protocol PrefsStorageImportFormat { }

// MARK: - Format Traits

/// Trait for ``PrefsStorageImportFormat`` that enables importing serialized storage content from a file on disk.
public protocol PrefsStorageImportFormatFileImportable where Self: PrefsStorageImportFormat {
    /// Read data into a raw dictionary, ready to be processed by the import strategy.
    func load(from file: URL) throws -> [String: Any]
}

/// Trait for ``PrefsStorageImportFormat`` that enables importing serialized storage content from raw data.
public protocol PrefsStorageImportFormatDataImportable where Self: PrefsStorageImportFormat {
    /// Read data into a raw dictionary, ready to be processed by the import strategy.
    func load(from data: Data) throws -> [String: Any]
}

/// Trait for ``PrefsStorageImportFormat`` that enables importing serialized storage content from string encoding/markup.
public protocol PrefsStorageImportFormatStringImportable where Self: PrefsStorageImportFormat {
    /// Read data into a raw dictionary, ready to be processed by the import strategy.
    func load(from string: String) throws -> [String: Any]
}

// MARK: - Default Implementation

extension PrefsStorageImportFormat where Self: PrefsStorageImportFormatDataImportable, Self: PrefsStorageImportFormatFileImportable {
    public func load(from file: URL) throws -> [String: Any] {
        let data = try Data(contentsOf: file)
        let dict = try load(from: data)
        return dict
    }
}
