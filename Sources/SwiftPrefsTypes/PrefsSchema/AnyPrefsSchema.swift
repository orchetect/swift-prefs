//
//  AnyPrefsSchema.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol for prefs schema containing type-erased prefs storage.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public protocol AnyPrefsSchema: PrefsSchema where SchemaStorage == AnyPrefsStorage { }
