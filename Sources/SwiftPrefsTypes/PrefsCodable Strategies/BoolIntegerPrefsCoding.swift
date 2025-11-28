//
//  BoolIntegerPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Coding strategy for `Bool` using `Int` as the encoded storage value (`1` or `0`).
public struct BoolIntegerPrefsCoding: PrefsCodable {
    public let decodingStrategy: DecodingStrategy
    
    public init(decodingStrategy: DecodingStrategy) {
        self.decodingStrategy = decodingStrategy
    }
    
    public func encode(prefsValue: Bool) -> Int? {
        prefsValue ? 1 : 0
    }
    
    public func decode(prefsValue: Int) -> Bool? {
        switch decodingStrategy {
        case .strict:
            switch prefsValue {
            case 1: true
            case 0: false
            default: nil
            }
        case .nearest:
            prefsValue >= 1
        }
    }
}

extension BoolIntegerPrefsCoding {
    /// Integer decoding strategy for ``BoolIntegerPrefsCoding``.
    public enum DecodingStrategy: Equatable, Hashable, Sendable {
        /// Strict decoding of a stored integer.
        /// Only `1` will be interpreted as `true` and `0` as `false`.
        /// Any other value will return `nil`.
        case strict
        
        /// Use the value nearest to `0` or `1` when reading a stored integer.
        /// `1` or greater will be interpreted as `true`.
        /// `0` or less will be interpreted as `false`.
        case nearest
    }
}

// MARK: - Static Constructor

extension PrefsCodable where Self == BoolIntegerPrefsCoding {
    /// Coding strategy for `Bool` using `Int` as the encoded storage value (`1` or `0`).
    public static func boolAsInteger(
        decodingStrategy: BoolIntegerPrefsCoding.DecodingStrategy = .nearest
    ) -> Self {
        BoolIntegerPrefsCoding(decodingStrategy: decodingStrategy)
    }
}

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue == Bool {
    /// Coding strategy for `Bool` using `Int` as the encoded storage value (`1` or `0`).
    public func boolAsInteger(
        decodingStrategy: BoolIntegerPrefsCoding.DecodingStrategy = .nearest
    ) -> PrefsCodingTuple<Self, BoolIntegerPrefsCoding> {
        PrefsCodingTuple(self, BoolIntegerPrefsCoding(decodingStrategy: decodingStrategy))
    }
}
