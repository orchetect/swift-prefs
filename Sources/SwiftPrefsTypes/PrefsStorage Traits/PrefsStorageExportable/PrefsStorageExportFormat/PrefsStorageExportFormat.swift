//
//  PrefsStorageExportFormat.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol that allows creating a type that implements storage content exporting to a particular data serialization
/// format.
public protocol PrefsStorageExportFormat { }

// MARK: - Format Traits

/// Trait for ``PrefsStorageExportFormat`` that enables exporting storage to a file on disk.
public protocol PrefsStorageExportFormatFileExportable where Self: PrefsStorageExportFormat {
    func export(storage: [String: Any], to file: URL) throws
}

/// Trait for ``PrefsStorageExportFormat`` that enables exporting storage as raw data.
public protocol PrefsStorageExportFormatDataExportable where Self: PrefsStorageExportFormat {
    func exportData(storage: [String: Any]) throws -> Data
}

/// Trait for ``PrefsStorageExportFormat`` that enables exporting storage as string encoding/markup.
public protocol PrefsStorageExportFormatStringExportable where Self: PrefsStorageExportFormat {
    func exportString(storage: [String: Any]) throws -> String
}

// MARK: - Default Implementation

extension PrefsStorageExportFormat where Self: PrefsStorageExportFormatDataExportable, Self: PrefsStorageExportFormatFileExportable {
    public func export(storage: [String: Any], to file: URL) throws {
        let data = try exportData(storage: storage)
        try data.write(to: file)
    }
}
