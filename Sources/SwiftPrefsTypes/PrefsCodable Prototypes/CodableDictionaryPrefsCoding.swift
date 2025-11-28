//
//  CodableDictionaryPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a dictionary keyed by `String` and containing values of a `Codable` type
/// to/from raw storage.
public struct CodableDictionaryPrefsCoding<Element>: PrefsCodable where Element: CodablePrefsCodable {
    public typealias Value = [String: Element.Value]
    public typealias StorageValue = [String: Element.StorageValue]
    public let elementCoding: Element
    
    public init(element: Element) {
        self.elementCoding = element
    }
    
    public func decode(prefsValue: StorageValue) -> Value? {
        // TODO: should assert or throw on elements that return nil?
        prefsValue.compactMapValues { elementCoding.decode(prefsValue: $0) }
    }
    
    public func encode(prefsValue: Value) -> StorageValue? {
        // TODO: should assert or throw on elements that return nil?
        prefsValue.compactMapValues { elementCoding.encode(prefsValue: $0) }
    }
}

// MARK: - Static Constructor

extension Dictionary where Key == String, Value: Codable, Value: Sendable {
    /// A prefs value coding strategy that encodes and decodes a dictionary keyed by `String` and containing a `Codable`
    /// value type to/from a dictionary of raw JSON `Data` value storage storage with default options.
    public static var jsonDataDictionaryPrefsCoding: CodableDictionaryPrefsCoding<JSONDataCodablePrefsCoding<Value>> {
        .init(element: JSONDataCodablePrefsCoding<Value>())
    }
    
    /// A prefs value coding strategy that encodes and decodes a dictionary keyed by `String` and containing a `Codable`
    /// value type to/from a dictionary of raw JSON `String` (UTF-8) value storage storage with default options.
    public static var jsonStringDictionaryPrefsCoding: CodableDictionaryPrefsCoding<
        JSONStringCodablePrefsCoding<Value>
    > {
        .init(element: JSONStringCodablePrefsCoding<Value>())
    }
}

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue == [String: JSONStringCodablePrefsCoding<Value>.Value] {
    /// A prefs value coding strategy that encodes and decodes a dictionary keyed by `String` and containing a `Codable`
    /// value type to/from a dictionary of raw JSON `Data` value storage storage with default options.
    public var jsonDataDictionaryPrefsCoding: PrefsCodingTuple<
        Self,
        CodableDictionaryPrefsCoding<JSONDataCodablePrefsCoding<StorageValue.Value>>
    > {
        PrefsCodingTuple(
            self,
            .init(element: JSONDataCodablePrefsCoding<StorageValue.Value>())
        )
    }
    
    /// A prefs value coding strategy that encodes and decodes a dictionary keyed by `String` and containing a `Codable`
    /// value type to/from a dictionary of raw JSON `String` (UTF-8) value storage storage with default options.
    public var jsonStringDictionaryPrefsCoding: PrefsCodingTuple<
        Self,
        CodableDictionaryPrefsCoding<JSONStringCodablePrefsCoding<StorageValue.Value>>
    > {
        PrefsCodingTuple(
            self,
            .init(element: JSONStringCodablePrefsCoding<StorageValue.Value>())
        )
    }
}
