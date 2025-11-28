//
//  IntegerStringPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Coding strategy for a concrete type conforming to `FixedWidthInteger` using `String` as the encoded storage value.
public struct IntegerStringPrefsCoding<Value>: PrefsCodable where Value: FixedWidthInteger, Value: Sendable {
    public init() { }
    
    public func encode(prefsValue: Value) -> String? {
        String(prefsValue)
    }
    
    public func decode(prefsValue: String) -> Value? {
        Value(prefsValue)
    }
}

// MARK: - Static Constructors

extension PrefsCodable where Self == IntegerStringPrefsCoding<Int> {
    /// Coding strategy for `Int` using `String` as the encoded storage value.
    public static var intAsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<UInt> {
    /// Coding strategy for `UInt` using `String` as the encoded storage value.
    public static var uIntAsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<Int8> {
    /// Coding strategy for `Int8` using `String` as the encoded storage value.
    public static var int8AsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<UInt8> {
    /// Coding strategy for `UInt8` using `String` as the encoded storage value.
    public static var uInt8AsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<Int16> {
    /// Coding strategy for `Int16` using `String` as the encoded storage value.
    public static var int16AsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<UInt16> {
    /// Coding strategy for `UInt16` using `String` as the encoded storage value.
    public static var uInt16AsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<Int32> {
    /// Coding strategy for `Int32` using `String` as the encoded storage value.
    public static var int32AsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<UInt32> {
    /// Coding strategy for `UInt32` using `String` as the encoded storage value.
    public static var uInt32AsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<Int64> {
    /// Coding strategy for `Int64` using `String` as the encoded storage value.
    public static var int64AsString: Self { .init() }
}

extension PrefsCodable where Self == IntegerStringPrefsCoding<UInt64> {
    /// Coding strategy for `UInt64` using `String` as the encoded storage value.
    public static var uInt64AsString: Self { .init() }
}

#if compiler(>=6.1)
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension PrefsCodable where Self == IntegerStringPrefsCoding<Int128> {
    /// Coding strategy for `Int128` using `String` as the encoded storage value.
    public static var int128AsString: Self { .init() }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension PrefsCodable where Self == IntegerStringPrefsCoding<UInt128> {
    /// Coding strategy for `UInt128` using `String` as the encoded storage value.
    public static var uInt128AsString: Self { .init() }
}
#endif

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue == Int {
    /// Coding strategy for `Int` using `String` as the encoded storage value.
    public var intAsString: PrefsCodingTuple<Self, IntegerStringPrefsCoding<Int>> {
        PrefsCodingTuple(self, IntegerStringPrefsCoding<Int>())
    }
}
