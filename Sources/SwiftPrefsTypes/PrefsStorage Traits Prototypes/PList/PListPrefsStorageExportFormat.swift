//
//  PListPrefsStorageExportFormat.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Prefs storage export format to export storage as plist (property list).
public struct PListPrefsStorageExportFormat: PrefsStorageExportFormat {
    public var format: PropertyListSerialization.PropertyListFormat
    public var strategy: any PrefsStorageExportStrategy
    
    public init(
        format: PropertyListSerialization.PropertyListFormat,
        strategy: some PrefsStorageExportStrategy
    ) {
        self.format = format
        self.strategy = strategy
    }
}

// MARK: - Static Constructor

extension PrefsStorageExportFormat where Self == PListPrefsStorageExportFormat {
    /// Prefs storage export format to export storage as plist (property list).
    public static func plist(
        format: PropertyListSerialization.PropertyListFormat = .xml,
        strategy: some PrefsStorageExportStrategy = .plist
    ) -> PListPrefsStorageExportFormat {
        PListPrefsStorageExportFormat(format: format, strategy: strategy)
    }
}

// MARK: - Format Traits

extension PListPrefsStorageExportFormat: PrefsStorageExportFormatFileExportable {
    // Note:
    // default implementation is provided when we conform to both
    // PrefsStorageExportFormatFileExportable & PrefsStorageExportFormatDataExportable
}

extension PListPrefsStorageExportFormat: PrefsStorageExportFormatDataExportable {
    public func exportData(storage: [String: Any]) throws -> Data {
        let prepared = try strategy.prepareForExport(storage: storage)
        let data = try prepared.plistData(format: format)
        return data
    }
}

extension PListPrefsStorageExportFormat: PrefsStorageExportFormatStringExportable {
    public func exportString(storage: [String: Any]) throws -> String {
        let prepared = try strategy.prepareForExport(storage: storage)
        let string = try prepared.plistString(encoding: .utf8)
        return string
    }
}
