//
//  IntegerPrefsCodingTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsCore
import Testing

@Suite
struct IntegerPrefsCodingTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite
        
        // MARK: - Static Constructors
        
        @Pref(coding: .uIntAsInt) var uInt_As_Int: UInt?
        
        @Pref(coding: .int8AsInt) var int8_As_Int: Int8?
        @Pref(coding: .uInt8AsInt) var uInt8_As_Int: UInt8?
        
        @Pref(coding: .int16AsInt) var int16_As_Int: Int16?
        @Pref(coding: .uInt16AsInt) var uInt16_As_Int: UInt16?
        
        @Pref(coding: .int32AsInt) var int32_As_Int: Int32?
        @Pref(coding: .uInt32AsInt) var uInt32_As_Int: UInt32?
        
        @Pref(coding: .int64AsInt) var int64_As_Int: Int64?
        @Pref(coding: .uInt64AsInt) var uInt64_As_Int: UInt64?
    }
    
    // MARK: - Static Constructors
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt_As_Int() async throws {
        let schema = TestSchema()
        
        // can't use UInt.max, would overflow Int. so we'll use Int.max
        schema.uInt_As_Int = 9223372036854775807 // Int.max
        #expect(schema.storage.storageValue(forKey: "uInt_As_Int") as Int? == 9223372036854775807)
        #expect(schema.uInt_As_Int == 9223372036854775807)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int8_As_Int() async throws {
        let schema = TestSchema()
        
        schema.int8_As_Int = 127 // Int8.max
        #expect(schema.storage.storageValue(forKey: "int8_As_Int") as Int? == 127)
        #expect(schema.int8_As_Int == 127)
        
        schema.int8_As_Int = -128 // Int8.min
        #expect(schema.storage.storageValue(forKey: "int8_As_Int") as Int? == -128)
        #expect(schema.int8_As_Int == -128)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt8AsString() async throws {
        let schema = TestSchema()
        
        schema.uInt8_As_Int = 255 // UInt8.max
        #expect(schema.storage.storageValue(forKey: "uInt8_As_Int") as Int? == 255)
        #expect(schema.uInt8_As_Int == 255)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int16_As_Int() async throws {
        let schema = TestSchema()
        
        schema.int16_As_Int = 32767 // Int16.max
        #expect(schema.storage.storageValue(forKey: "int16_As_Int") as Int? == 32767)
        #expect(schema.int16_As_Int == 32767)
        
        schema.int16_As_Int = -32768 // Int16.min
        #expect(schema.storage.storageValue(forKey: "int16_As_Int") as Int? == -32768)
        #expect(schema.int16_As_Int == -32768)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt16AsString() async throws {
        let schema = TestSchema()
        
        schema.uInt16_As_Int = 65535 // UInt16.max
        #expect(schema.storage.storageValue(forKey: "uInt16_As_Int") as Int? == 65535)
        #expect(schema.uInt16_As_Int == 65535)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int32_As_Int() async throws {
        let schema = TestSchema()
        
        schema.int32_As_Int = 2147483647 // Int32.max
        #expect(schema.storage.storageValue(forKey: "int32_As_Int") as Int? == 2147483647)
        #expect(schema.int32_As_Int == 2147483647)
        
        schema.int32_As_Int = -2147483648 // Int32.min
        #expect(schema.storage.storageValue(forKey: "int32_As_Int") as Int? == -2147483648)
        #expect(schema.int32_As_Int == -2147483648)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt32AsString() async throws {
        let schema = TestSchema()
        
        schema.uInt32_As_Int = 23456
        #expect(schema.storage.storageValue(forKey: "uInt32_As_Int") as Int? == 23456)
        #expect(schema.uInt32_As_Int == 23456)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int64_As_Int() async throws {
        let schema = TestSchema()
        
        schema.int64_As_Int = 9223372036854775807 // Int64.max
        #expect(schema.storage.storageValue(forKey: "int64_As_Int") as Int? == 9223372036854775807)
        #expect(schema.int64_As_Int == 9223372036854775807)
        
        schema.int64_As_Int = -9223372036854775808 // Int64.min
        #expect(schema.storage.storageValue(forKey: "int64_As_Int") as Int? == -9223372036854775808)
        #expect(schema.int64_As_Int == -9223372036854775808)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt64AsString() async throws {
        let schema = TestSchema()
        
        // can't use UInt64.max, would overflow Int. so we'll use Int.max
        schema.uInt64_As_Int = 9223372036854775807 // Int.max
        #expect(schema.storage.storageValue(forKey: "uInt64_As_Int") as Int? == 9223372036854775807)
        #expect(schema.uInt64_As_Int == 9223372036854775807)
    }
}
