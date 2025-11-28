//
//  ChainingEncodingStrategiesTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsCore
import Testing

@Suite
struct ChainingEncodingStrategiesTests {
    enum MyType: Int {
        case foo = 0x12345678
        case bar = 0x98765432
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite
        
        @Pref(coding: .compressedData(algorithm: .lzfse).base64DataString()) public var foo: Data?
        
        // not logic-tested, just to check if the compiler can infer the protocol extensions
        @Pref(
            coding: URL.jsonDataPrefsCoding
                .compressedData(algorithm: .lzfse)
                .compressedData(algorithm: .zlib)
                .base64DataString()
        ) public var bar: URL?
        
        @Pref(coding: FloatingPointSign.rawRepresentablePrefsCoding)
        public var fpsA: FloatingPointSign?
        
        @Pref(coding: FloatingPointSign.rawRepresentablePrefsCoding.intAsString)
        public var fpsB: FloatingPointSign?
        
        @Pref(coding: .uInt32AsInt) var binaryInt: UInt32?
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func chainedEncodingA() async throws {
        let schema = TestSchema()
        
        let testData = Data((1 ... 100).map(\.self))
        
        schema.foo = testData
        
        let encoded: String = try #require(schema.storage.storageValue(forKey: "foo"))
        
        // check that the storage value is the base-64 string of the compressed data
        #expect(
            encoded ==
                "YnZ4LWQAAAABAgMEBQYHCAkKCwwNDg8QERITFBUW"
                + "FxgZGhscHR4fICEiIyQlJicoKSorLC0uLzAxMjM0"
                + "NTY3ODk6Ozw9Pj9AQUJDREVGR0hJSktMTU5PUFFS"
                + "U1RVVldYWVpbXF1eX2BhYmNkYnZ4JA=="
        )
        
        let decoded = try #require(schema.foo)
        
        #expect(decoded == testData)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func chainedEncoding_fpsA() async throws {
        let schema = TestSchema()
        
        schema.fpsA = .plus
        
        #expect(schema.storage.storageValue(forKey: "fpsA") as Int? == FloatingPointSign.plus.rawValue)
        #expect(schema.fpsA == .plus)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func chainedEncoding_fpsB() async throws {
        let schema = TestSchema()
        
        schema.fpsB = .plus
        
        #expect(schema.storage.storageValue(forKey: "fpsB") as String? == String(FloatingPointSign.plus.rawValue))
        #expect(schema.fpsB == .plus)
    }
}
