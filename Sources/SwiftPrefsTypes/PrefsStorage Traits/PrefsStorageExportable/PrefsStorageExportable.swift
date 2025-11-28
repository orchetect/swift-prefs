//
//  PrefsStorageExportable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables exporting storage contents.
public protocol PrefsStorageExportable where Self: PrefsStorage {
    /// Returns the storage contents as a dictionary.
    /// This method is a required implementation detail for storage export methods provided by
    /// ``PrefsStorageExportable`` and is not meant to be used directly.
    func dictionaryRepresentation() throws -> [String: Any]
    
    /// Export the storage contents to a file on disk.
    func export<Format: PrefsStorageExportFormat>(
        format: Format,
        to file: URL
    ) throws where Format: PrefsStorageExportFormatFileExportable
    
    /// Export the storage contents as raw data.
    func exportData<Format: PrefsStorageExportFormat>(
        format: Format
    ) throws -> Data where Format: PrefsStorageExportFormatDataExportable
    
    /// Export the storage contents encoded in a format that supports string encoding/markup.
    func exportString<Format: PrefsStorageExportFormat>(
        format: Format
    ) throws -> String where Format: PrefsStorageExportFormatStringExportable
}

// MARK: - Default Implementation

extension PrefsStorage where Self: PrefsStorageExportable {
    public func export<Format: PrefsStorageExportFormat>(
        format: Format,
        to file: URL
    ) throws where Format: PrefsStorageExportFormatFileExportable {
        try format.export(storage: dictionaryRepresentation(), to: file)
    }
    
    public func exportData<Format: PrefsStorageExportFormat>(
        format: Format
    ) throws -> Data where Format: PrefsStorageExportFormatDataExportable {
        try format.exportData(storage: dictionaryRepresentation())
    }
    
    public func exportString<Format: PrefsStorageExportFormat>(
        format: Format
    ) throws -> String where Format: PrefsStorageExportFormatStringExportable {
        try format.exportString(storage: dictionaryRepresentation())
    }
}
