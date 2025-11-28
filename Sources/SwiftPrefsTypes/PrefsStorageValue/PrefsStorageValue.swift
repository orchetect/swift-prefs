//
//  PrefsStorageValue.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol adopted by format-agnostic atomic value types that are valid for storage in prefs storage.
public protocol PrefsStorageValue where Self: Equatable, Self: Sendable { }
