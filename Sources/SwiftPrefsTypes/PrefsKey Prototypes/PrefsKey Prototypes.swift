//
//  PrefsKey Prototypes.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

// MARK: - Atomic

/// Generic concrete pref key with an atomic value type.
public struct AnyAtomicPrefsKey<Value: Sendable & PrefsStorageValue>: PrefsKey {
    public typealias StorageValue = Value

    public let key: String
    public let coding = AtomicPrefsCoding<Value>()

    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with an atomic value type and a default value.
public struct AnyDefaultedAtomicPrefsKey<Value: Sendable & PrefsStorageValue>: DefaultedPrefsKey {
    public typealias StorageValue = Value

    public let key: String
    public let defaultValue: Value
    public let coding = AtomicPrefsCoding<Value>()

    // allows type inference:
    // let foo = AnyDefaultedAtomicPrefsKey(key: "foo", defaultValue: 1)
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - Base

/// Generic concrete pref key with a different value type from its raw storage type.
public struct AnyPrefsKey<Coding: PrefsCodable>: PrefsKey {
    public typealias Value = Coding.Value
    public typealias StorageValue = Coding.StorageValue

    public let key: String
    public let coding: Coding

    // allows type inference:
    // let foo = AnyPrefsKey(key: "foo", coding: MyCustomCoding())
    // where MyCustomCoding conforms to `PrefsCodable`
    public init(key: String, coding: Coding) {
        self.key = key
        self.coding = coding
    }

    // allows type inference:
    // let foo = AnyPrefsKey(key: "foo", encode: { String($0) }, decode: { Int($0) })
    public init<Value, StorageValue>(
        key: String,
        encode: @escaping @Sendable (Value) -> StorageValue?,
        decode: @escaping @Sendable (StorageValue) -> Value?
    ) where Coding == PrefsCoding<Value, StorageValue> {
        self.key = key
        coding = PrefsCoding<Value, StorageValue>(encode: encode, decode: decode)
    }
}

/// Generic concrete pref key with a different value type from its raw storage type and a default value.
public struct AnyDefaultedPrefsKey<Coding: PrefsCodable>: DefaultedPrefsKey {
    public typealias Value = Coding.Value
    public typealias StorageValue = Coding.StorageValue

    public let key: String
    public let defaultValue: Value
    public let coding: Coding

    // allows type inference:
    // let foo = AnyDefaultedPrefsKey(key: "foo", defaultValue: 123, coding: MyCustomCoding())
    // where MyCustomCoding conforms to `PrefsCodable`
    public init(
        key: String,
        defaultValue: Value,
        coding: Coding
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.coding = coding
    }

    // allows type inference:
    // let foo = AnyDefaultedPrefsKey(key: "foo", defaultValue: 123, encode: { String($0) }, decode: { Int($0) })
    public init<Value, StorageValue>(
        key: String,
        defaultValue: Value,
        encode: @escaping @Sendable (Value) -> StorageValue?,
        decode: @escaping @Sendable (StorageValue) -> Value?
    ) where Coding == PrefsCoding<Value, StorageValue> {
        self.key = key
        self.defaultValue = defaultValue
        coding = .init(encode: encode, decode: decode)
    }
}

// MARK: - RawRepresentable

/// Generic concrete pref key with a `RawRepresentable` value type.
public struct AnyRawRepresentablePrefsKey<Value: RawRepresentable & Sendable>: PrefsKey
    where Value.RawValue: PrefsStorageValue
{
    public typealias StorageValue = Value.RawValue

    public let key: String
    public let coding = RawRepresentablePrefsCoding<Value>()

    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `RawRepresentable` value type and a default value.
public struct AnyDefaultedRawRepresentablePrefsKey<Value: RawRepresentable & Sendable>: DefaultedPrefsKey
    where Value.RawValue: PrefsStorageValue
{
    public typealias StorageValue = Value.RawValue

    public let key: String
    public let defaultValue: Value
    public let coding = RawRepresentablePrefsCoding<Value>()

    // allows type inference:
    // let foo = AnyDefaultedRawRepresentablePrefsKey(key: "foo", defaultValue: MyRawRepEnum.foo)
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - Codable

/// Generic concrete pref key with a `Codable` value type.
public struct AnyCodablePrefsKey<
    Value: Codable & Sendable,
    StorageValue: PrefsStorageValue,
    Encoder: TopLevelEncoder & Sendable,
    Decoder: TopLevelDecoder & Sendable
>: PrefsKey
    where StorageValue == Encoder.Output,
    Encoder.Output: PrefsStorageValue,
    Decoder.Input: PrefsStorageValue,
    Encoder.Output == Decoder.Input
{
    public let key: String
    public let coding: CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>

    // allows type inference:
    // let foo = AnyCodablePrefsKey(key: "foo", coding: MyCoding())
    public init(key: String, coding: CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>) {
        self.key = key
        self.coding = coding
    }

    // allows type inference:
    // let foo = AnyCodablePrefsKey(
    //     key: "foo",
    //     value: Int.self,
    //     storageValue: Data.self,
    //     encoder: JSONEncoder(), decoder: JSONDecoder()
    // )
    public init(
        key: String,
        value: Value.Type,
        storageValue: StorageValue.Type,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) {
        self.key = key
        coding = CodablePrefsCoding(value: value, storageValue: storageValue, encoder: encoder(), decoder: decoder())
    }
}

/// Generic concrete pref key with a `Codable` value type and a default value.
public struct AnyDefaultedCodablePrefsKey<
    Value: Codable & Sendable,
    StorageValue: PrefsStorageValue,
    Encoder: TopLevelEncoder & Sendable,
    Decoder: TopLevelDecoder & Sendable
>: DefaultedPrefsKey
    where StorageValue == Encoder.Output,
    Encoder.Output: PrefsStorageValue,
    Decoder.Input: PrefsStorageValue,
    Encoder.Output == Decoder.Input
{
    public let key: String
    public let defaultValue: Value
    public let coding: CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>

    // allows type inference:
    // let foo = AnyDefaultedCodablePrefsKey(key: "foo", defaultValue: 123, coding: MyCoding())
    public init(
        key: String,
        defaultValue: Value,
        coding: CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.coding = coding
    }

    // allows type inference:
    // let foo = AnyDefaultedCodablePrefsKey(
    //     key: "foo",
    //     defaultValue: 123,
    //     storageValue: Data.self,
    //     encoder: JSONEncoder(),
    //     decoder: JSONDecoder()
    // )
    public init(
        key: String,
        defaultValue: Value,
        storageValue: StorageValue.Type,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) {
        self.key = key
        self.defaultValue = defaultValue
        coding = CodablePrefsCoding(value: Value.self, storageValue: storageValue, encoder: encoder(), decoder: decoder())
    }
}

// MARK: - JSON Data Codable

/// Generic concrete pref key with a `Codable` value type using JSON `Data` encoding.
public struct AnyJSONDataCodablePrefsKey<Value: Codable & Sendable>: PrefsKey {
    public let key: String
    public let coding = JSONDataCodablePrefsCoding<Value>()

    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `Codable` value type using JSON `Data` encoding and a default value.
public struct AnyDefaultedJSONDataCodablePrefsKey<Value: Codable & Sendable>: DefaultedPrefsKey {
    public let key: String
    public let defaultValue: Value
    public let coding = JSONDataCodablePrefsCoding<Value>()

    // allows type inference:
    // let foo = AnyDefaultedJSONDataCodablePrefsKey(key: "foo", defaultValue: 123)
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - JSON String Codable

/// Generic concrete pref key with a `Codable` value type using JSON `String` (UTF-8) encoding.
public struct AnyJSONStringCodablePrefsKey<Value: Codable & Sendable>: PrefsKey {
    public let key: String
    public let coding = JSONStringCodablePrefsCoding<Value>()

    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `Codable` value type using JSON `String` (UTF-8) encoding and a default value.
public struct AnyDefaultedJSONStringCodablePrefsKey<Value: Codable & Sendable>: DefaultedPrefsKey {
    public let key: String
    public let defaultValue: Value
    public let coding = JSONStringCodablePrefsCoding<Value>()

    // allows type inference:
    // let foo = AnyDefaultedJSONStringCodablePrefsKey(key: "foo", defaultValue: 123)
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
