//
//  RawRepresentableDictionaryPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a dictionary of a `RawRepresentable` type to/from raw storage using the element's
/// `RawValue` as its storage value.
public struct RawRepresentableDictionaryPrefsCoding<Element>: PrefsCodable where Element: RawRepresentablePrefsCodable {
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

extension Dictionary where Key == String, Value: RawRepresentable, Value.RawValue: PrefsStorageValue, Value: Sendable {
    /// A prefs key that encodes and decodes a dictionary of a `RawRepresentable` type to/from raw storage using the
    /// element's `RawValue` as its storage value.
    public static var rawRepresentableDictionaryPrefsCoding: RawRepresentableDictionaryPrefsCoding<RawRepresentablePrefsCoding<Value>> {
        .init(element: RawRepresentablePrefsCoding<Value>())
    }
}

// MARK: - Chaining Constructor

// there does not seem to be a reasonable way to implement a chaining constructor
