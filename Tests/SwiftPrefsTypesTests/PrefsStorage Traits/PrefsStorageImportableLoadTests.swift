//
//  PrefsStorageImportableLoadTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsTypes
import Testing

@Suite(.serialized)
struct PrefsStorageImportableLoadTests {
    static let domain = "com.orchetect.swift-prefs.\(type(of: Self.self))"
    
    static var base: [String: any PrefsStorageValue] {
        [
            "foo": "string",
            "bar": 123,
            "baz": 3.14 as Double
        ]
    }
    
    static var storageBackends: [AnyPrefsStorage] {
        [
            AnyPrefsStorage(.dictionary(root: base)),
            AnyPrefsStorage(.userDefaults(suite: UserDefaults(suiteName: domain)!)) // content added in init()
        ]
    }
    
    // MARK: - Init
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
        
        // load default contents
        let defaults = UserDefaults(suiteName: Self.domain)!
        defaults.merge(Self.base)
        
        // verify loaded default contents
        try #require(defaults.string(forKey: "foo") == "string")
        try #require(defaults.integer(forKey: "bar") == 123)
        try #require(defaults.double(forKey: "baz") == 3.14)
        try #require(defaults.object(forKey: "boo") == nil)
    }
    
    // MARK: - Tests
    
    @Test(arguments: Self.storageBackends)
    func loadRawReinitializing(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        let updatedKeys = try storage.load(from: newContent, by: .reinitializing)
        
        #expect(updatedKeys == ["foo", "bar", "boo"])
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == Data([0x01, 0x02]))
        #expect(storage.storageValue(forKey: "baz") == Double?.none) // old key removed
        #expect(storage.storageValue(forKey: "boo") == true)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadRawUpdating(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        let updatedKeys = try storage.load(from: newContent, by: .updating)
        
        #expect(updatedKeys == ["foo", "bar", "boo"])
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == Data([0x01, 0x02]))
        #expect(storage.storageValue(forKey: "baz") == 3.14 as Double) // key not contained in new content; old value
        #expect(storage.storageValue(forKey: "boo") == true)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadRawUpdatingWithPredicate(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        let updatedKeys = try storage.load(
            from: newContent,
            by: .updatingWithPredicate { key, oldValue, newValue in
                switch key {
                case "foo":
                    .takeNewValue
                case "bar":
                    .preserveOldValue
                case "boo":
                    Issue.record("Predicate should not be called for a new key that does already exist in storage.")
                    throw CocoaError(.featureUnsupported)
                default:
                    Issue.record("All relevant key collision cases are handled here. There should not be a default fallthrough event.")
                    throw CocoaError(.featureUnsupported)
                }
            }
        )
        
        #expect(updatedKeys == ["foo", "boo"])
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == 123) // old value preserved via predicate
        #expect(storage.storageValue(forKey: "baz") == 3.14 as Double) // key not contained in new content; old value
        #expect(storage.storageValue(forKey: "boo") == true)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadUnsafeReinitializing(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        let updatedKeys = try storage.load(unsafe: newContent, by: .reinitializing)
        
        #expect(updatedKeys == ["foo", "bar", "boo"])
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == Data([0x01, 0x02]))
        #expect(storage.storageValue(forKey: "baz") == Double?.none) // old key removed
        #expect(storage.storageValue(forKey: "boo") == true)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadUnsafeUpdating(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        let updatedKeys = try storage.load(unsafe: newContent, by: .updating)
        
        #expect(updatedKeys == ["foo", "bar", "boo"])
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == Data([0x01, 0x02]))
        #expect(storage.storageValue(forKey: "baz") == 3.14 as Double) // key not contained in new content; old value
        #expect(storage.storageValue(forKey: "boo") == true)
    }
}
