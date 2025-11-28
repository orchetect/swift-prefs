//
//  CodableDictionaryTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsCore
import Testing

@Suite(.serialized)
struct CodableDictionaryTests {
    static let domain = "com.orchetect.swift-prefs.\(type(of: Self.self))"
    
    static var suite: UserDefaults {
        UserDefaults(suiteName: domain)!
    }
    
    enum CodableEnum: String, Codable {
        case one
        case two
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage: AnyPrefsStorage
        @StorageMode var storageMode: PrefsStorageMode
        
        init(storage: PrefsStorage, storageMode: PrefsStorageMode) {
            self.storage = AnyPrefsStorage(storage)
            self.storageMode = storageMode
        }
        
        enum Key: String {
            case dictA
            case dictADefaulted
            case dictB
            case dictBDefaulted
            case dictC
            case dictCDefaulted
            case dictD
            case dictDDefaulted
        }
        
        // encode dictionary as a single JSON string
        // (this is possible since a dictionary of Codable key & value types is implicitly Codable)
        @Pref(
            key: Key.dictA.rawValue,
            coding: [String: CodableEnum].jsonStringPrefsCoding
        ) var dictA: [String: CodableEnum]?
        @Pref(
            key: Key.dictADefaulted.rawValue,
            coding: [String: CodableEnum].jsonStringPrefsCoding
        ) var dictADefaulted: [String: CodableEnum] = ["a": .one, "b": .two]
        
        // encode dictionary as a single JSON data blob
        // (this is possible since a dictionary of Codable key & value types is implicitly Codable)
        @Pref(
            key: Key.dictB.rawValue,
            coding: [String: CodableEnum].jsonDataPrefsCoding
        ) var dictB: [String: CodableEnum]?
        @Pref(
            key: Key.dictBDefaulted.rawValue,
            coding: [String: CodableEnum].jsonDataPrefsCoding
        ) var dictBDefaulted: [String: CodableEnum] = ["a": .one, "b": .two]
        
        // encode dictionary as a a dictionary of JSON string values
        @Pref(
            key: Key.dictC.rawValue,
            coding: [String: CodableEnum].jsonStringDictionaryPrefsCoding
        ) var dictC: [String: CodableEnum]?
        @Pref(
            key: Key.dictCDefaulted.rawValue,
            coding: [String: CodableEnum].jsonStringDictionaryPrefsCoding
        ) var dictCDefaulted: [String: CodableEnum] = ["a": .one, "b": .two]
        
        // encode dictionary as a a dictionary of JSON data blob values
        @Pref(
            key: Key.dictD.rawValue,
            coding: [String: CodableEnum].jsonDataDictionaryPrefsCoding
        ) var dictD: [String: CodableEnum]?
        @Pref(
            key: Key.dictDDefaulted.rawValue,
            coding: [String: CodableEnum].jsonDataDictionaryPrefsCoding
        ) var dictDDefaulted: [String: CodableEnum] = ["a": .one, "b": .two]
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    static var schemas: [TestSchema] {
        [
            TestSchema(storage: .dictionary, storageMode: .cachedReadStorageWrite),
            TestSchema(storage: .dictionary, storageMode: .storageOnly),
            TestSchema(storage: .userDefaults(suite: suite), storageMode: .cachedReadStorageWrite),
            TestSchema(storage: .userDefaults(suite: suite), storageMode: .storageOnly)
        ]
    }
    
    // MARK: - Init
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
    }
    
    // MARK: - Tests
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func singleJSONString(schema: TestSchema) throws {
        schema.dictA = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictA == ["a": .two, "b": .two, "c": .one])
        
        #expect(schema.dictADefaulted == ["a": .one, "b": .two])
        
        schema.dictADefaulted = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictADefaulted == ["a": .two, "b": .two, "c": .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictA.rawValue) as? String)
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictADefaulted.rawValue) as? String)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func singleJSONData(schema: TestSchema) throws {
        schema.dictB = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictB == ["a": .two, "b": .two, "c": .one])
        
        #expect(schema.dictBDefaulted == ["a": .one, "b": .two])
        
        schema.dictBDefaulted = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictBDefaulted == ["a": .two, "b": .two, "c": .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictB.rawValue) as? Data)
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictBDefaulted.rawValue) as? Data)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func arrayOfJSONStringElements(schema: TestSchema) throws {
        schema.dictC = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictC == ["a": .two, "b": .two, "c": .one])
        
        #expect(schema.dictCDefaulted == ["a": .one, "b": .two])
        
        schema.dictCDefaulted = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictCDefaulted == ["a": .two, "b": .two, "c": .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictC.rawValue) as? [String: String])
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictCDefaulted.rawValue) as? [String: String])
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func arrayOfJSONDataElements(schema: TestSchema) throws {
        schema.dictD = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictD == ["a": .two, "b": .two, "c": .one])
        
        #expect(schema.dictDDefaulted == ["a": .one, "b": .two])
        
        schema.dictDDefaulted = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictDDefaulted == ["a": .two, "b": .two, "c": .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictD.rawValue) as? [String: Data])
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictDDefaulted.rawValue) as? [String: Data])
    }
    
    /// Edge case test to ensure we don't run afoul of force-unwrap exceptions.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func modifyNonExistentKey(schema: TestSchema) throws {
        schema.dictADefaulted["newKey"] = .one
        #expect(schema.dictADefaulted["newKey"] == .one)
    }
}
