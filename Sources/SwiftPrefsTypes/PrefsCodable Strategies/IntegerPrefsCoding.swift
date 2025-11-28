//
//  IntegerPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Coding strategy for a concrete type conforming to `BinaryInteger` using `Int` as the encoded storage value.
public struct IntegerPrefsCoding<Value>: PrefsCodable where Value: BinaryInteger, Value: Sendable {
    public init() { }
    
    public func encode(prefsValue: Value) -> Int? {
        Int(exactly: prefsValue)
    }
    
    public func decode(prefsValue: Int) -> Value? {
        Value(exactly: prefsValue)
    }
}

// MARK: - Static Constructor

// Note: do not offer `Int` since it is already an atomic prefs storage value type

extension PrefsCodable where Self == IntegerPrefsCoding<UInt> {
    /// Coding strategy for `UInt` using `Int` as the encoded storage value.
    ///
    /// > Important:
    /// >
    /// > Values above `Int.max` will silently fail to be stored.
    /// > Consider encoding as `String` or raw `Data` to ensure lossless storage of very large `UInt` values.
    public static var uIntAsInt: Self { .init() }
}

extension PrefsCodable where Self == IntegerPrefsCoding<Int8> {
    /// Coding strategy for `Int8` using `Int` as the encoded storage value.
    public static var int8AsInt: Self { .init() }
}

extension PrefsCodable where Self == IntegerPrefsCoding<UInt8> {
    /// Coding strategy for `UInt8` using `Int` as the encoded storage value.
    public static var uInt8AsInt: Self { .init() }
}

extension PrefsCodable where Self == IntegerPrefsCoding<Int16> {
    /// Coding strategy for `Int16` using `Int` as the encoded storage value.
    public static var int16AsInt: Self { .init() }
}

extension PrefsCodable where Self == IntegerPrefsCoding<UInt16> {
    /// Coding strategy for `UInt16` using `Int` as the encoded storage value.
    public static var uInt16AsInt: Self { .init() }
}

extension PrefsCodable where Self == IntegerPrefsCoding<Int32> {
    /// Coding strategy for `Int32` using `Int` as the encoded storage value.
    public static var int32AsInt: Self { .init() }
}

extension PrefsCodable where Self == IntegerPrefsCoding<UInt32> {
    /// Coding strategy for `UInt32` using `Int` as the encoded storage value.
    public static var uInt32AsInt: Self { .init() }
}

extension PrefsCodable where Self == IntegerPrefsCoding<Int64> {
    /// Coding strategy for `Int64` using `Int` as the encoded storage value.
    public static var int64AsInt: Self { .init() }
}

extension PrefsCodable where Self == IntegerPrefsCoding<UInt64> {
    /// Coding strategy for `UInt64` using `Int` as the encoded storage value.
    ///
    /// > Important:
    /// >
    /// > Values above `Int.max` will silently fail to be stored.
    /// > Consider encoding as `String` or raw `Data` to ensure lossless storage of very large `UInt64` values.
    public static var uInt64AsInt: Self { .init() }
}

// MARK: - Chaining Constructor

// note: non-Int integers do not conform to PrefsStorageValue so we can't offer coding strategy chaining methods.
