//
//  RawRepresentablePrefsCodable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Defines value encoding and decoding for reading and writing a `RawRepresentable` value to prefs storage.
public protocol RawRepresentablePrefsCodable: PrefsCodable where Value: RawRepresentable, Value.RawValue == StorageValue { }
