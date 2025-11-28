//
//  JSONPrefsStorageExportFormat.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Prefs storage export format to export storage as JSON.
///
/// Since JSON is a does not support all atomic types that ``PrefsStorage`` supports, it is required that you create and
/// supply your own export strategy.
public struct JSONPrefsStorageExportFormat: PrefsStorageExportFormat {
    public var options: JSONSerialization.WritingOptions
    public var strategy: any PrefsStorageExportStrategy
    
    public init(
        options: JSONSerialization.WritingOptions = [],
        strategy: any PrefsStorageExportStrategy
    ) {
        self.options = options
        self.strategy = strategy
    }
}

// MARK: - Static Constructor

extension PrefsStorageExportFormat where Self == JSONPrefsStorageExportFormat {
    /// Prefs storage export format to export storage as JSON.
    ///
    /// Since JSON is a does not support all atomic types that ``PrefsStorage`` supports, it is required that you create
    /// and supply your own export strategy.
    public static func json(
        options: JSONSerialization.WritingOptions = [],
        strategy: any PrefsStorageExportStrategy
    ) -> JSONPrefsStorageExportFormat {
        JSONPrefsStorageExportFormat(options: options, strategy: strategy)
    }
}

// MARK: - Format Traits

extension JSONPrefsStorageExportFormat: PrefsStorageExportFormatFileExportable {
    // Note:
    // default implementation is provided when we conform to both
    // PrefsStorageExportFormatFileExportable & PrefsStorageExportFormatDataExportable
}

extension JSONPrefsStorageExportFormat: PrefsStorageExportFormatDataExportable {
    public func exportData(storage: [String: Any]) throws -> Data {
        let prepared = try strategy.prepareForExport(storage: storage)
        let data = try prepared.jsonData(options: options)
        return data
    }
}

extension JSONPrefsStorageExportFormat: PrefsStorageExportFormatStringExportable {
    public func exportString(storage: [String: Any]) throws -> String {
        let prepared = try strategy.prepareForExport(storage: storage)
        let string = try prepared.jsonString(options: options, encoding: .utf8)
        return string
    }
}
