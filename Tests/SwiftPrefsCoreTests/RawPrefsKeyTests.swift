//
//  RawPrefsKeyTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsCore
import Testing

@Suite
struct RawPrefsKeyTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite

        @RawPref var array: [Any]?
        @RawPref var arrayDefaulted: [Any] = ["string", 123]
        @RawPref var dict: [String: Any]?
        @RawPref var dictDefaulted: [String: Any] = ["foo": "string", "bar": 123]
        
        // custom keys
        @RawPref(key: "arrayB") var array2: [Any]?
        @RawPref(key: "arrayDefaultedB") var arrayDefaulted2: [Any] = ["string", 123]
        @RawPref(key: "dictB") var dict2: [String: Any]?
        @RawPref(key: "dictDefaultedB") var dictDefaulted2: [String: Any] = ["foo": "string", "bar": 123]
    }
    
    /// Just ensure that default storage state is correct.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func baseline() {
        let prefs = TestSchema()
        
        #expect(prefs.array == nil)
        
        #expect(prefs.arrayDefaulted[0] as? String == "string")
        #expect(prefs.arrayDefaulted[1] as? Int == 123)
        
        #expect(prefs.dict == nil)
        
        #expect(prefs.dictDefaulted["foo"] as? String == "string")
        #expect(prefs.dictDefaulted["bar"] as? Int == 123)
        
        #expect(prefs.array2 == nil)
        
        #expect(prefs.arrayDefaulted2[0] as? String == "string")
        #expect(prefs.arrayDefaulted2[1] as? Int == 123)
        
        #expect(prefs.dict2 == nil)
        
        #expect(prefs.dictDefaulted2["foo"] as? String == "string")
        #expect(prefs.dictDefaulted2["bar"] as? Int == 123)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func arrayMutation() {
        let prefs = TestSchema()
        
        // replace array
        prefs.array = ["new string", 500.5 as Double]
        #expect(prefs.array?[0] as? String == "new string")
        #expect(prefs.array?[1] as? Double == 500.5)
        
        // mutate array member
        prefs.array?[0] = "replaced string"
        #expect(prefs.array?[0] as? String == "replaced string")
        #expect(prefs.array?[1] as? Double == 500.5)
        
        // remove pref key
        prefs.array = nil
        #expect(prefs.array == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func arrayDefaultedMutation() {
        let prefs = TestSchema()
        
        // replace array
        prefs.arrayDefaulted = ["new string", 500.5 as Double]
        #expect(prefs.arrayDefaulted[0] as? String == "new string")
        #expect(prefs.arrayDefaulted[1] as? Double == 500.5)
        
        // mutate array member
        prefs.arrayDefaulted[0] = "replaced string"
        #expect(prefs.arrayDefaulted[0] as? String == "replaced string")
        #expect(prefs.arrayDefaulted[1] as? Double == 500.5)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func dictMutation() {
        let prefs = TestSchema()
        
        // replace array
        prefs.dict = ["one": "new string", "two": 500.5 as Double]
        #expect(prefs.dict?["one"] as? String == "new string")
        #expect(prefs.dict?["two"] as? Double == 500.5)
        
        // mutate array member
        prefs.dict?["one"] = "replaced string"
        #expect(prefs.dict?["one"] as? String == "replaced string")
        #expect(prefs.dict?["two"] as? Double == 500.5)
        
        // remove pref key
        prefs.array = nil
        #expect(prefs.array == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func dictDefaultedMutation() {
        let prefs = TestSchema()
        
        // replace array
        prefs.dictDefaulted = ["one": "new string", "two": 500.5 as Double]
        #expect(prefs.dictDefaulted["one"] as? String == "new string")
        #expect(prefs.dictDefaulted["two"] as? Double == 500.5)
        
        // mutate array member
        prefs.dictDefaulted["one"] = "replaced string"
        #expect(prefs.dictDefaulted["one"] as? String == "replaced string")
        #expect(prefs.dictDefaulted["two"] as? Double == 500.5)
        
        // can't set nil
    }
    
    /// Just test that one of the pref declarations that uses a custom key name actually stores its data with that key name.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func customKey() {
        let prefs = TestSchema()
        
        prefs.array2 = ["new string", 500.5 as Double]
        
        let readValue = prefs.storage.unsafeStorageValue(forKey: "arrayB") as? [Any]
        #expect(readValue?[0] as? String == "new string")
        #expect(readValue?[1] as? Double == 500.5)
    }
}
