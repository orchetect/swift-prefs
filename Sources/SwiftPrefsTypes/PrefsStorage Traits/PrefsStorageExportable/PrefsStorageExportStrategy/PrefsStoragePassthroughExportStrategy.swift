//
//  PrefsStoragePassthroughExportStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// A prefs storage export strategy that passes local storage data through without any modification, conversion, or
/// casting.
public struct PrefsStoragePassthroughExportStrategy {
    public init() { }
}

extension PrefsStoragePassthroughExportStrategy: PrefsStorageExportStrategy {
    public func prepareForExport(storage: [String: Any]) throws -> [String: Any] {
        // pass storage through as-is, no casting or conversions necessary
        storage
    }
}

// MARK: - Static Constructor

extension PrefsStorageExportStrategy where Self == PrefsStoragePassthroughExportStrategy {
    /// A prefs storage export strategy that passes local storage data through without any modification, conversion,
    /// or casting.
    public static var passthrough: PrefsStoragePassthroughExportStrategy {
        PrefsStoragePassthroughExportStrategy()
    }
}
