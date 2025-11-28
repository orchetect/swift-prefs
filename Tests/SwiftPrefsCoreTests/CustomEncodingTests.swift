//
//  CustomEncodingTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsCore
import Testing

/// Test `PrefsCodable` implementation that uses custom `getValue(in:)` and `setValue(to:in:)` method overrides to convert
/// to/from raw prefs storage data without using any of the included abstraction protocols such as
/// `RawRepresentablePrefsCodable` or `CodablePrefsCodable`.
@Suite
struct CustomEncodingTests {
    struct NonCodableNonRawRepresentable: Equatable {
        var value: Int
        
        init(value: Int) {
            self.value = value
        }
        
        init?(encoded: String) {
            guard encoded.hasPrefix("VALUE:"),
                  let val = Int(encoded.dropFirst(6))
            else { return nil }
            value = val
        }
        
        func encoded() -> String {
            "VALUE:(\(value))"
        }
    }
    
    struct CustomPrefCoding: PrefsCodable {
        typealias Value = NonCodableNonRawRepresentable
        typealias StorageValue = String
        
        func decode(prefsValue: StorageValue) -> Value? {
            NonCodableNonRawRepresentable(encoded: prefsValue)
        }
        
        func encode(prefsValue: Value) -> StorageValue? {
            prefsValue.encoded()
        }
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite

        enum Key {
            static let custom = "custom"
            static let customDefaulted = "customDefaulted"
        }
        
        @Pref(key: Key.custom, coding: CustomPrefCoding()) var custom: NonCodableNonRawRepresentable?
        @Pref(key: Key.customDefaulted, coding: CustomPrefCoding()) var customDefaulted: NonCodableNonRawRepresentable = .init(value: 1)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func customValueEncoding() {
        let schema = TestSchema()
        
        #expect(schema.custom?.value == nil)
        
        schema.custom = NonCodableNonRawRepresentable(value: 42)
        #expect(schema.custom?.value == 42)
        
        schema.custom?.value = 5
        #expect(schema.custom?.value == 5)
        
        schema.custom = nil
        #expect(schema.custom == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func customDefaultedValueEncoding() {
        let schema = TestSchema()
        
        #expect(schema.customDefaulted == NonCodableNonRawRepresentable(value: 1))
        
        schema.customDefaulted = NonCodableNonRawRepresentable(value: 42)
        #expect(schema.customDefaulted.value == 42)
        
        schema.customDefaulted = NonCodableNonRawRepresentable(value: 5)
        #expect(schema.customDefaulted.value == 5)
    }
}
