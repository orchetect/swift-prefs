//
//  PListPrefsStorageImportFormat.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Prefs storage import format to import plist (property list) contents.
public struct PListPrefsStorageImportFormat: PrefsStorageImportFormat {
    public var strategy: any PrefsStorageImportStrategy
    
    public init(
        strategy: any PrefsStorageImportStrategy
    ) {
        self.strategy = strategy
    }
}

// MARK: - Static Constructor

extension PrefsStorageImportFormat where Self == PListPrefsStorageImportFormat {
    /// Prefs storage import format to import plist (property list) contents.
    public static func plist(
        strategy: any PrefsStorageImportStrategy = .plist
    ) -> PListPrefsStorageImportFormat {
        PListPrefsStorageImportFormat(strategy: strategy)
    }
}

// MARK: - Format Traits

extension PListPrefsStorageImportFormat: PrefsStorageImportFormatFileImportable {
    // Note:
    // default implementation is provided when we conform to both
    // PrefsStorageImportFormatFileImportable & PrefsStorageImportFormatDataImportable
}

extension PListPrefsStorageImportFormat: PrefsStorageImportFormatDataImportable {
    public func load(from data: Data) throws -> [String: Any] {
        let loaded: [String: Any] = try .init(plist: data)
        let prepared = try strategy.prepareForImport(storage: loaded)
        return prepared
    }
}

extension PListPrefsStorageImportFormat: PrefsStorageImportFormatStringImportable {
    public func load(from string: String) throws -> [String: Any] {
        let loaded: [String: Any] = try .init(plist: string)
        let prepared = try strategy.prepareForImport(storage: loaded)
        return prepared
    }
}
