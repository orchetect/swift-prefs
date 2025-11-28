//
//  IntegerStringPrefsCodingTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsCore
import Testing

@Suite
struct IntegerStringPrefsCodingTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite
        
        // MARK: - Static Constructors
        
        @Pref(coding: .intAsString) var int_As_String: Int?
        @Pref(coding: .uIntAsString) var uInt_As_String: UInt?
        
        @Pref(coding: .int8AsString) var int8_As_String: Int8?
        @Pref(coding: .uInt8AsString) var uInt8_As_String: UInt8?
        
        @Pref(coding: .int16AsString) var int16_As_String: Int16?
        @Pref(coding: .uInt16AsString) var uInt16_As_String: UInt16?
        
        @Pref(coding: .int32AsString) var int32_As_String: Int32?
        @Pref(coding: .uInt32AsString) var uInt32_As_String: UInt32?
        
        @Pref(coding: .int64AsString) var int64_As_String: Int64?
        @Pref(coding: .uInt64AsString) var uInt64_As_String: UInt64?
        
        #if compiler(>=6.1)
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Pref(coding: .int128AsString) var int128_As_String: Int128?
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Pref(coding: .uInt128AsString) var uInt128_As_String: UInt128?
        #endif
        
        // MARK: - Chaining Constructor
        
        @Pref(coding: FloatingPointSign.rawRepresentablePrefsCoding.intAsString)
        var fpsInt_As_String: FloatingPointSign?
    }
    
    // MARK: - Static Constructors
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int_As_String() async throws {
        let schema = TestSchema()
        
        schema.int_As_String = 9223372036854775807 // Int.max (64-bit system)
        #expect(schema.storage.storageValue(forKey: "int_As_String") as String? == "9223372036854775807")
        #expect(schema.int_As_String == 9223372036854775807)
        
        schema.int_As_String = -9223372036854775808 // Int.min (64-bit system)
        #expect(schema.storage.storageValue(forKey: "int_As_String") as String? == "-9223372036854775808")
        #expect(schema.int_As_String == -9223372036854775808)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt_As_String() async throws {
        let schema = TestSchema()
        
        schema.uInt_As_String = 18446744073709551615 // UInt.max
        #expect(schema.storage.storageValue(forKey: "uInt_As_String") as String? == "18446744073709551615")
        #expect(schema.uInt_As_String == 18446744073709551615)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int8_As_String() async throws {
        let schema = TestSchema()
        
        schema.int8_As_String = 127 // Int8.max
        #expect(schema.storage.storageValue(forKey: "int8_As_String") as String? == "127")
        #expect(schema.int8_As_String == 127)
        
        schema.int8_As_String = -128 // Int8.min
        #expect(schema.storage.storageValue(forKey: "int8_As_String") as String? == "-128")
        #expect(schema.int8_As_String == -128)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt8AsString() async throws {
        let schema = TestSchema()
        
        schema.uInt8_As_String = 255 // UInt8.max
        #expect(schema.storage.storageValue(forKey: "uInt8_As_String") as String? == "255")
        #expect(schema.uInt8_As_String == 255)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int16_As_String() async throws {
        let schema = TestSchema()
        
        schema.int16_As_String = 32767 // Int16.max
        #expect(schema.storage.storageValue(forKey: "int16_As_String") as String? == "32767")
        #expect(schema.int16_As_String == 32767)
        
        schema.int16_As_String = -32768 // Int16.min
        #expect(schema.storage.storageValue(forKey: "int16_As_String") as String? == "-32768")
        #expect(schema.int16_As_String == -32768)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt16AsString() async throws {
        let schema = TestSchema()
        
        schema.uInt16_As_String = 65535 // UInt16.max
        #expect(schema.storage.storageValue(forKey: "uInt16_As_String") as String? == "65535")
        #expect(schema.uInt16_As_String == 65535)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int32_As_String() async throws {
        let schema = TestSchema()
        
        schema.int32_As_String = 2147483647 // Int32.max
        #expect(schema.storage.storageValue(forKey: "int32_As_String") as String? == "2147483647")
        #expect(schema.int32_As_String == 2147483647)
        
        schema.int32_As_String = -2147483648 // Int32.min
        #expect(schema.storage.storageValue(forKey: "int32_As_String") as String? == "-2147483648")
        #expect(schema.int32_As_String == -2147483648)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt32AsString() async throws {
        let schema = TestSchema()
        
        schema.uInt32_As_String = 23456
        #expect(schema.storage.storageValue(forKey: "uInt32_As_String") as String? == "23456")
        #expect(schema.uInt32_As_String == 23456)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func int64_As_String() async throws {
        let schema = TestSchema()
        
        schema.int64_As_String = 9223372036854775807 // Int64.max
        #expect(schema.storage.storageValue(forKey: "int64_As_String") as String? == "9223372036854775807")
        #expect(schema.int64_As_String == 9223372036854775807)
        
        schema.int64_As_String = -9223372036854775808 // Int64.min
        #expect(schema.storage.storageValue(forKey: "int64_As_String") as String? == "-9223372036854775808")
        #expect(schema.int64_As_String == -9223372036854775808)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func uInt64AsString() async throws {
        let schema = TestSchema()
        
        schema.uInt64_As_String = 18446744073709551615 // UInt64.max
        #expect(schema.storage.storageValue(forKey: "uInt64_As_String") as String? == "18446744073709551615")
        #expect(schema.uInt64_As_String == 18446744073709551615)
    }
    
    #if compiler(>=6.1)
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test
    func int128_As_String() async throws {
        let schema = TestSchema()
        
        schema.int128_As_String = 170141183460469231731687303715884105727 // Int128.max
        #expect(
            schema.storage.storageValue(forKey: "int128_As_String") as String?
                == "170141183460469231731687303715884105727"
        )
        #expect(schema.int128_As_String == 170141183460469231731687303715884105727)
    }
    #endif
    
    #if compiler(>=6.1)
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test
    func uInt128AsString() async throws {
        let schema = TestSchema()
        
        schema.uInt128_As_String = 340282366920938463463374607431768211455 // UInt128.max
        #expect(
            schema.storage.storageValue(forKey: "uInt128_As_String") as String?
                == "340282366920938463463374607431768211455"
        )
        #expect(schema.uInt128_As_String == 340282366920938463463374607431768211455)
    }
    #endif
    
    // MARK: - Chaining Constructor
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func fps_intAsString() async throws {
        let schema = TestSchema()
        
        schema.fpsInt_As_String = .plus
        #expect(
            schema.storage.storageValue(forKey: "fpsInt_As_String") as String?
                == String(FloatingPointSign.plus.rawValue)
        )
        #expect(schema.fpsInt_As_String == .plus)
    }
}
