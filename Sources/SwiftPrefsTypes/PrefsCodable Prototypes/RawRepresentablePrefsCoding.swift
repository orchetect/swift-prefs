//
//  RawRepresentablePrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs value coding strategy which uses a `RawRepresentable` type's `RawValue` as its storage value.
public struct RawRepresentablePrefsCoding<Value>: RawRepresentablePrefsCodable
    where Value: Sendable, Value: RawRepresentable, Value.RawValue: PrefsStorageValue
{
    public typealias Value = Value
    public typealias StorageValue = Value.RawValue
    
    public init() { }
}

// MARK: - Static Constructor

extension RawRepresentable where Self: Sendable, Self.RawValue: PrefsStorageValue {
    /// A prefs value coding strategy which uses a `RawRepresentable` type's `RawValue` as its storage value.
    public static var rawRepresentablePrefsCoding: RawRepresentablePrefsCoding<Self> {
        RawRepresentablePrefsCoding()
    }
}

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue: RawRepresentable, StorageValue.RawValue: PrefsStorageValue {
    // (Note that the availability of this chaining property is very rare, but still technically possible)
    
    /// A prefs value coding strategy which uses a `RawRepresentable` type's `RawValue` as its storage value.
    public var rawRepresentablePrefsCoding: RawRepresentablePrefsCoding<StorageValue> {
        RawRepresentablePrefsCoding()
    }
}
