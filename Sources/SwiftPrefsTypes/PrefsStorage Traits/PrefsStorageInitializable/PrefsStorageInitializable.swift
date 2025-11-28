//
//  PrefsStorageInitializable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables initializing storage contents.
public protocol PrefsStorageInitializable where Self: PrefsStorageImportable {
    /// Initialize with storage contents by importing a file on disk.
    init<Format: PrefsStorageImportFormat>(
        from url: URL,
        format: Format
    ) throws where Format: PrefsStorageImportFormatFileImportable
    
    /// Initialize with storage contents by importing raw file contents.
    init<Format: PrefsStorageImportFormat>(
        from data: Data,
        format: Format
    ) throws where Format: PrefsStorageImportFormatDataImportable
    
    /// Initialize with storage contents by importing raw file contents for a format that supports string
    /// encoding/markup.
    init<Format: PrefsStorageImportFormat>(
        from string: String,
        format: Format
    ) throws where Format: PrefsStorageImportFormatStringImportable
}
