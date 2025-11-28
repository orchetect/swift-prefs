//
//  PrefsStorageArrayTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsTypes
import Testing

@Suite(.serialized)
struct PrefsStorageArrayTests {
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
        storage.setStorageValue(forKey: "foo", to: [1, 2, 3])
        
        let key = AnyAtomicPrefsKey<[Int]>(key: "foo")
        
        let value: [Int] = try #require(storage.value(forKey: key))
        
        #expect(value == [1, 2, 3])
    }
    
    @Test(arguments: Self.storageBackends)
    func stringArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["a", "b", "c"])
        
        let key = AnyAtomicPrefsKey<[String]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == ["a", "b", "c"])
    }
    
    @Test(arguments: Self.storageBackends)
    func boolArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [true, false, true])
        
        let key = AnyAtomicPrefsKey<[Bool]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [true, false, true])
    }
    
    @Test(arguments: Self.storageBackends)
    func doubleArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [1.5, 2.5, 3.5] as [Double])
        
        let key = AnyAtomicPrefsKey<[Double]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func floatArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [1.5, 2.5, 3.5] as [Float])
        
        let key = AnyAtomicPrefsKey<[Float]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func dataArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [Data([0x01]), Data([0x02])])
        
        let key = AnyAtomicPrefsKey<[Data]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [Data([0x01]), Data([0x02])])
    }
    
    @Test(arguments: Self.storageBackends)
    func anyPrefsArrayArray(storage: AnyPrefsStorage) async throws {
        let array: [Any] = [1, 2, "string", true]
        storage.setUnsafeStorageValue(forKey: "foo", to: array)
        
        let value: [Any] = try #require(storage.unsafeStorageValue(forKey: "foo") as? [Any])
        try #require(value.count == 4)
        
        #expect(value[0] as? Int == 1)
        #expect(value[1] as? Int == 2)
        #expect(value[2] as? String == "string")
        #expect(value[3] as? Bool == true)
    }
    
    // MARK: - Nested
    
    @Test(arguments: Self.storageBackends)
    func nestedStringArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [["a", "b"], ["c"]])
        
        let key = AnyAtomicPrefsKey<[[String]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [["a", "b"], ["c"]])
    }
    
    @Test(arguments: Self.storageBackends)
    func nestedAnyArray(storage: AnyPrefsStorage) async throws {
        let array: [Any] = [["a", 2], [true]]
        storage.setUnsafeStorageValue(forKey: "foo", to: array)
        
        let value: [Any] = try #require(storage.unsafeStorageValue(forKey: "foo") as? [Any])
        try #require(value.count == 2)
        
        let subArray1 = try #require(value[0] as? [Any])
        try #require(subArray1.count == 2)
        #expect(subArray1[0] as? String == "a")
        #expect(subArray1[1] as? Int == 2)
        
        let subArray2 = try #require(value[1] as? [Any])
        try #require(subArray2.count == 1)
        #expect(subArray2[0] as? Bool == true)
    }
}
