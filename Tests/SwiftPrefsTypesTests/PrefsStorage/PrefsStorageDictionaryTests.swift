//
//  PrefsStorageDictionaryTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsTypes
import Testing

@Suite(.serialized)
struct PrefsStorageDictionaryTests {
    static let domain = "com.orchetect.swift-prefs.\(type(of: Self.self))"
    
    static var storageBackends: [AnyPrefsStorage] {
        [
            AnyPrefsStorage(.dictionary),
            AnyPrefsStorage(.userDefaults(suite: UserDefaults(suiteName: domain)!))
        ]
    }
    
    // MARK: - Init
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
    }
    
    // MARK: - Atomic
    
    @Test(arguments: Self.storageBackends)
    func intArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1, 2, 3]])
        
        let key = AnyAtomicPrefsKey<[String: [Int]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1, 2, 3])
    }
    
    @Test(arguments: Self.storageBackends)
    func stringArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": ["a", "b", "c"]])
        
        let key = AnyAtomicPrefsKey<[String: [String]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == ["a", "b", "c"])
    }
    
    @Test(arguments: Self.storageBackends)
    func boolArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [true, false, true]])
        
        let key = AnyAtomicPrefsKey<[String: [Bool]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [true, false, true])
    }
    
    @Test(arguments: Self.storageBackends)
    func doubleArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1.5, 2.5, 3.5] as [Double]])
        
        let key = AnyAtomicPrefsKey<[String: [Double]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func floatArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1.5, 2.5, 3.5] as [Float]])
        
        let key = AnyAtomicPrefsKey<[String: [Float]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func dataArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [Data([0x01]), Data([0x02])]])
        
        let key = AnyAtomicPrefsKey<[String: [Data]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [Data([0x01]), Data([0x02])])
    }
    
    @Test(arguments: Self.storageBackends)
    func anyDictionaryArray(storage: AnyPrefsStorage) async throws {
        let valueDict: [String: Any] = ["one": 1, "two": 2, "string": "string", "bool": true]
        storage.setUnsafeStorageValue(forKey: "foo", to: valueDict)
        
        // TODO: test a new key type to accommodate `[String: Any]`?
        
        let value: [String: Any] = try #require(storage.unsafeStorageValue(forKey: "foo") as? [String: Any])
        
        try #require(value.count == 4)
        #expect(value["one"] as? Int == 1)
        #expect(value["two"] as? Int == 2)
        #expect(value["string"] as? String == "string")
        #expect(value["bool"] as? Bool == true)
    }
    
    // MARK: - Nested
    
    @Test(arguments: Self.storageBackends)
    func nestedAnyDictionaryArray(storage: AnyPrefsStorage) async throws {
        let valueDictInner: [String: Any] = ["one": 1, "two": 2, "string": "string", "bool": true]
        let valueDictOuter = ["bar": valueDictInner]
        storage.setUnsafeStorageValue(forKey: "foo", to: valueDictOuter)
        
        // TODO: test a new key type to accommodate `[String: Any]`?
        
        let value: [String: Any] = try #require(storage.unsafeStorageValue(forKey: "foo") as? [String: Any])
        
        try #require(value.count == 1)
        let subValue = try #require(value["bar"] as? [String: Any])
        
        try #require(subValue.count == 4)
        #expect(subValue["one"] as? Int == 1)
        #expect(subValue["two"] as? Int == 2)
        #expect(subValue["string"] as? String == "string")
        #expect(subValue["bool"] as? Bool == true)
    }
}
