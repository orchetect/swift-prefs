//
//  PListPrefsStorageExportStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Prefs storage export strategy to export storage as plist (property list).
public struct PListPrefsStorageExportStrategy {
    public init() { }
}

extension PListPrefsStorageExportStrategy: PrefsStorageExportStrategy {
    public func prepareForExport(storage: [String: Any]) throws -> [String: Any] {
        // pass storage through as-is, no casting or conversions necessary
        storage
    }
}

// MARK: - Static Constructor

extension PrefsStorageExportStrategy where Self == PListPrefsStorageExportStrategy {
    /// Prefs storage export strategy to export storage as plist (property list).
    public static var plist: PListPrefsStorageExportStrategy {
        PListPrefsStorageExportStrategy()
    }
}
