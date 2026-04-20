//
//  PrefsStorageExportable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables exporting storage contents.
public protocol PrefsStorageExportable where Self: PrefsStorage {
    /// Returns the storage contents as a dictionary.
    /// This method is a required implementation detail for storage export methods provided by
    /// ``PrefsStorageExportable`` and is not meant to be used directly.
    func dictionaryRepresentation() throws -> [String: Any]

    /// Export the storage contents to a file on disk.
    func export(
        format: some PrefsStorageExportFormat & PrefsStorageExportFormatFileExportable,
        to file: URL
    ) throws

    /// Export the storage contents as raw data.
    func exportData(
        format: some PrefsStorageExportFormat & PrefsStorageExportFormatDataExportable
    ) throws -> Data

    /// Export the storage contents encoded in a format that supports string encoding/markup.
    func exportString(
        format: some PrefsStorageExportFormat & PrefsStorageExportFormatStringExportable
    ) throws -> String
}

// MARK: - Default Implementation

extension PrefsStorage where Self: PrefsStorageExportable {
    public func export(
        format: some PrefsStorageExportFormat & PrefsStorageExportFormatFileExportable,
        to file: URL
    ) throws {
        try format.export(storage: dictionaryRepresentation(), to: file)
    }

    public func exportData(
        format: some PrefsStorageExportFormat & PrefsStorageExportFormatDataExportable
    ) throws -> Data {
        try format.exportData(storage: dictionaryRepresentation())
    }

    public func exportString(
        format: some PrefsStorageExportFormat & PrefsStorageExportFormatStringExportable
    ) throws -> String {
        try format.exportString(storage: dictionaryRepresentation())
    }
}
