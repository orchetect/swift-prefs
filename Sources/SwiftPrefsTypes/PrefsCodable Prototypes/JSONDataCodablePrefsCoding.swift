//
//  JSONDataCodablePrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs value coding strategy that encodes and decodes a `Codable` type to/from raw JSON `Data` storage with default
/// options.
///
/// > Note:
/// > If custom `JSONEncoder`/`JSONDecoder` options are required, override the default implementation(s) of
/// > `prefEncoder()` and/or `prefDecoder()` methods to return an encoder/decoder with necessary options configured.
public struct JSONDataCodablePrefsCoding<Value>: JSONDataCodablePrefsCodable
    where Value: Codable, Value: Sendable
{
    public typealias Value = Value
    
    public init() { }
}

// MARK: - Static Constructor

extension /* Codable */ Encodable where Self: Decodable, Self: Sendable {
    /// A prefs value coding strategy that encodes and decodes a `Codable` type to/from raw JSON `Data` storage with
    /// default options.
    public static var jsonDataPrefsCoding: JSONDataCodablePrefsCoding<Self> {
        JSONDataCodablePrefsCoding()
    }
}

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue == JSONDataCodablePrefsCoding<Value>.Value {
    /// A prefs value coding strategy that encodes and decodes a `Codable` type to/from raw JSON `Data` storage with
    /// default options.
    public var jsonDataPrefsCoding: PrefsCodingTuple<Self, JSONDataCodablePrefsCoding<Value>> {
        PrefsCodingTuple(
            self,
            JSONDataCodablePrefsCoding()
        )
    }
}
