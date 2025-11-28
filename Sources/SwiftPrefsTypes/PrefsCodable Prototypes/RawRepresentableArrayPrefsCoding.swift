//
//  RawRepresentableArrayPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes an array of a `RawRepresentable` type to/from raw storage using the element's
/// `RawValue` as its storage value.
public struct RawRepresentableArrayPrefsCoding<Element>: PrefsCodable where Element: RawRepresentablePrefsCodable {
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

extension Array where Element: RawRepresentable, Element.RawValue: PrefsStorageValue, Element: Sendable {
    /// A prefs key that encodes and decodes an array of a `RawRepresentable` type to/from raw storage using the
    /// element's `RawValue` as its storage value.
    public static var rawRepresentableArrayPrefsCoding: RawRepresentableArrayPrefsCoding<RawRepresentablePrefsCoding<Element>> {
        .init(element: RawRepresentablePrefsCoding<Element>())
    }
}

// MARK: - Chaining Constructor

// there does not seem to be a reasonable way to implement a chaining constructor
