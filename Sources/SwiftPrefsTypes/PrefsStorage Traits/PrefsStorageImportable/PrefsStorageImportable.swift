//
//  PrefsStorageImportable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables loading storage contents.
///
/// > Note:
/// >
/// > Loading storage contents will not update local cache properties for any `@Pref` keys defined in a `@PrefsSchema`
/// > whose `storageMode` is set to `cachedReadStorageWrite`. The storage mode must be set to `storageOnly` to ensure
/// > data loads correctly.
public protocol PrefsStorageImportable where Self: PrefsStorage {
    /// Load key/values into storage.
    ///
    /// - Returns: Key names for key/value pairs that were imported.
    @discardableResult
    func load(
        from contents: [String: any PrefsStorageValue],
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String>

    /// Load key/values into storage.
    ///
    /// - Returns: Key names for key/value pairs that were imported.
    @discardableResult
    func load(
        unsafe contents: [String: Any],
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String>

    /// Import storage contents from a file on disk.
    ///
    /// - Returns: Key names for key/value pairs that were imported.
    @discardableResult
    func load(
        from file: URL,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatFileImportable,
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String>

    /// Import storage contents from a format's raw data.
    ///
    /// - Returns: Key names for key/value pairs that were imported.
    @discardableResult
    func load(
        from data: Data,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatDataImportable,
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String>

    /// Import storage contents from a format that supports string encoding/markup.
    ///
    /// - Returns: Key names for key/value pairs that were imported.
    @discardableResult
    func load(
        from string: String,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatStringImportable,
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String>
}

// MARK: - Default Implementation

extension PrefsStorage where Self: PrefsStorageImportable {
    @discardableResult
    public func load(
        from file: URL,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatFileImportable,
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String> {
        let loaded = try format.load(from: file)
        return try load(unsafe: loaded, by: behavior)
    }

    @discardableResult
    public func load(
        from data: Data,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatDataImportable,
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String> {
        let loaded = try format.load(from: data)
        return try load(unsafe: loaded, by: behavior)
    }

    @discardableResult
    public func load(
        from string: String,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatStringImportable,
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String> {
        let loaded = try format.load(from: string)
        return try load(unsafe: loaded, by: behavior)
    }
}
