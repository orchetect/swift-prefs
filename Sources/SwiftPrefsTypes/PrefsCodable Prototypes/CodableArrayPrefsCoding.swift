//
//  CodableArrayPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes an array of a `Codable` type to/from raw storage.
public struct CodableArrayPrefsCoding<Element>: PrefsCodable where Element: CodablePrefsCodable {
    public typealias Value = [Element.Value]
    public typealias StorageValue = [Element.StorageValue]
    public let elementCoding: Element
    
    public init(element: Element) {
        self.elementCoding = element
    }
    
    public func decode(prefsValue: StorageValue) -> Value? {
        // TODO: should assert or throw on elements that return nil?
        prefsValue.compactMap { elementCoding.decode(prefsValue: $0) }
    }
    
    public func encode(prefsValue: Value) -> StorageValue? {
        // TODO: should assert or throw on elements that return nil?
        prefsValue.compactMap { elementCoding.encode(prefsValue: $0) }
    }
}

// MARK: - Static Constructor

extension Array where Element: Codable, Element: Sendable {
    /// A prefs value coding strategy that encodes and decodes an array of a `Codable` type to/from an array of raw JSON
    /// `Data` element storage with default options.
    public static var jsonDataArrayPrefsCoding: CodableArrayPrefsCoding<JSONDataCodablePrefsCoding<Element>> {
        .init(element: JSONDataCodablePrefsCoding<Element>())
    }
    
    /// A prefs value coding strategy that encodes and decodes an array of a `Codable` type to/from an array of raw JSON
    /// `String` (UTF-8) element storage with default options.
    public static var jsonStringArrayPrefsCoding: CodableArrayPrefsCoding<JSONStringCodablePrefsCoding<Element>> {
        .init(element: JSONStringCodablePrefsCoding<Element>())
    }
}

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue == [JSONStringCodablePrefsCoding<Value>.Value] {
    /// A prefs value coding strategy that encodes and decodes an array of a `Codable` type to/from an array of raw JSON
    /// `Data` element storage with default options.
    public var jsonDataArrayPrefsCoding: PrefsCodingTuple<
        Self,
        CodableArrayPrefsCoding<JSONDataCodablePrefsCoding<StorageValue.Element>>
    > {
        PrefsCodingTuple(
            self,
            .init(element: JSONDataCodablePrefsCoding<StorageValue.Element>())
        )
    }
    
    /// A prefs value coding strategy that encodes and decodes an array of a `Codable` type to/from an array of raw JSON
    /// `String` (UTF-8) element storage with default options.
    public var jsonStringArrayPrefsCoding: PrefsCodingTuple<
        Self,
        CodableArrayPrefsCoding<JSONStringCodablePrefsCoding<StorageValue.Element>>
    > {
        PrefsCodingTuple(
            self,
            .init(element: JSONStringCodablePrefsCoding<StorageValue.Element>())
        )
    }
}
