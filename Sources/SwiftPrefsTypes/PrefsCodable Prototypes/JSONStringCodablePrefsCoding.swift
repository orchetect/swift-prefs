//
//  JSONStringCodablePrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs value coding strategy that encodes and decodes a `Codable` type to/from raw JSON `String` (UTF-8) storage
/// with default options.
///
/// > Note:
/// > If custom `JSONEncoder`/`JSONDecoder` options are required, override the default implementation(s) of
/// > `prefEncoder()` and/or `prefDecoder()` methods to return an encoder/decoder with necessary options configured.
public struct JSONStringCodablePrefsCoding<Value>: JSONStringCodablePrefsCodable
    where Value: Codable, Value: Sendable
{
    public typealias Value = Value
    
    public init() { }
}

// MARK: - Static Constructor

extension /* Codable */ Encodable where Self: Decodable, Self: Sendable {
    /// A prefs value coding strategy that encodes and decodes a `Codable` type to/from raw JSON `String` (UTF-8)
    /// storage with default options.
    public static var jsonStringPrefsCoding: JSONStringCodablePrefsCoding<Self> {
        JSONStringCodablePrefsCoding()
    }
}

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue == JSONStringCodablePrefsCoding<Value>.Value {
    /// A prefs value coding strategy that encodes and decodes a `Codable` type to/from raw JSON `String` (UTF-8)
    /// storage with default options.
    public var jsonStringPrefsCoding: PrefsCodingTuple<Self, JSONStringCodablePrefsCoding<Value>> {
        PrefsCodingTuple(
            self,
            JSONStringCodablePrefsCoding()
        )
    }
}
