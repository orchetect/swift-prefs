//
//  PrefsStoragePassthroughImportStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs storage import strategy that passes imported data through without any modification, conversion, or
/// casting.
public struct PrefsStoragePassthroughImportStrategy {
    public init() { }
}

extension PrefsStoragePassthroughImportStrategy: PrefsStorageImportStrategy {
    public func prepareForImport(storage: [String: Any]) throws -> [String: Any] {
        // pass storage through as-is, no casting or conversions necessary
        storage
    }
}

// MARK: - Static Constructor

extension PrefsStorageImportStrategy where Self == PrefsStoragePassthroughImportStrategy {
    /// A prefs storage import strategy that passes imported data through without any modification, conversion, or
    /// casting.
    public static var passthrough: PrefsStoragePassthroughImportStrategy {
        PrefsStoragePassthroughImportStrategy()
    }
}
