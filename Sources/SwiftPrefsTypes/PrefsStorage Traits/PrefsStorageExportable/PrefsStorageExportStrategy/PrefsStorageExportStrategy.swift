//
//  PrefsStorageExportStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Export strategy used by prefs export formats.
public protocol PrefsStorageExportStrategy {
    /// The main method used to prepare local storage for export.
    func prepareForExport(storage: [String: Any]) throws -> [String: Any]
}
