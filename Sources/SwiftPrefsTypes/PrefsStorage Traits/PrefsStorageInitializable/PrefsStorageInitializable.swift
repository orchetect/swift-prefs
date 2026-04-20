//
//  PrefsStorageInitializable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables initializing storage contents.
public protocol PrefsStorageInitializable where Self: PrefsStorageImportable {
    /// Initialize with storage contents by importing a file on disk.
    init(
        from url: URL,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatFileImportable
    ) throws

    /// Initialize with storage contents by importing raw file contents.
    init(
        from data: Data,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatDataImportable
    ) throws

    /// Initialize with storage contents by importing raw file contents for a format that supports string
    /// encoding/markup.
    init(
        from string: String,
        format: some PrefsStorageImportFormat & PrefsStorageImportFormatStringImportable
    ) throws
}
