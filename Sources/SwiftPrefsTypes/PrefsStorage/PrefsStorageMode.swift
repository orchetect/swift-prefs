//
//  PrefsStorageMode.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Pref schema property access storage mode for ``PrefsSchema`` implementations.
public enum PrefsStorageMode {
    /// Storage-backed only with no intermediate cache.
    ///
    /// Directly read and write from prefs schema `storage` on every access to pref properties without cacheing.
    /// This may have performance impacts on frequent accesses or for data types with expensive decoding operations.
    case storageOnly
    
    /// Cache-backed read, storage-backed write.
    ///
    /// Reads property values from storage on initialization, then utilizes an internal local cache for improved read
    /// performance thereafter. All writes are always written to storage immediately.
    ///
    /// This mode is recommended in most use cases for improved performance.
    ///
    /// > Note:
    /// > This mode is suitable for storage that cannot or will not change externally. Changes made externally
    /// > will not be reflected within the schema during its lifespan and will be overwritten with cached values.
    case cachedReadStorageWrite
    
    // TODO: could implement this feature in future if there is a way to enumerate all prefs in a PrefsSchema
    // /// Cache only.
    // /// Reads property values from storage on initialization, then operates exclusively from cache for reads and
    // /// writes.
    // ///
    // /// Writes are not automatically written to storage. Changes to pref values must be manually committed by calling
    // /// `commit()` on the prefs schema which writes all cached pref values to storage. It is recommended to do this
    // /// only periodically or upon context switches (such as when the user invokes a Save Settings command, or your
    // /// application quits).
    // ///
    // /// This storage mode is preferable for rare use cases where performance is critical, allowing storage commits
    // /// to be invoked electively only during optimal conditions.
    // ///
    // /// > Note:
    // /// > This mode is suitable for storage that cannot or will not change externally. Changes made externally
    // /// > will not be reflected within the schema and will be overwritten with cached values.
    // case cacheOnly
}

extension PrefsStorageMode: Equatable { }

extension PrefsStorageMode: Hashable { }

extension PrefsStorageMode: Sendable { }
