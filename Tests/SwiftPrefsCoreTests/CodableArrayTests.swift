//
//  CodableArrayTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsCore
import Testing

@Suite(.serialized)
struct CodableArrayTests {
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
            case arrayA
            case arrayADefaulted
            case arrayB
            case arrayBDefaulted
            case arrayC
            case arrayCDefaulted
            case arrayD
            case arrayDDefaulted
        }
        
        // encode array as a single JSON string
        // (this is possible since an array of a Codable type is implicitly Codable)
        @Pref(
            key: Key.arrayA.rawValue,
            coding: [CodableEnum].jsonStringPrefsCoding
        ) var arrayA: [CodableEnum]?
        @Pref(
            key: Key.arrayADefaulted.rawValue,
            coding: [CodableEnum].jsonStringPrefsCoding
        ) var arrayADefaulted: [CodableEnum] = [.one, .two]
        
        // encode array as a single JSON data blob
        // (this is possible since an array of a Codable type is implicitly Codable)
        @Pref(
            key: Key.arrayB.rawValue,
            coding: [CodableEnum].jsonDataPrefsCoding
        ) var arrayB: [CodableEnum]?
        @Pref(
            key: Key.arrayBDefaulted.rawValue,
            coding: [CodableEnum].jsonDataPrefsCoding
        ) var arrayBDefaulted: [CodableEnum] = [.one, .two]
        
        // encode array as a an array of JSON string elements
        @Pref(
            key: Key.arrayC.rawValue,
            coding: [CodableEnum].jsonStringArrayPrefsCoding
        ) var arrayC: [CodableEnum]?
        @Pref(
            key: Key.arrayCDefaulted.rawValue,
            coding: [CodableEnum].jsonStringArrayPrefsCoding
        ) var arrayCDefaulted: [CodableEnum] = [.one, .two]
        
        // encode array as a an array of JSON data blob elements
        @Pref(
            key: Key.arrayD.rawValue,
            coding: [CodableEnum].jsonDataArrayPrefsCoding
        ) var arrayD: [CodableEnum]?
        @Pref(
            key: Key.arrayDDefaulted.rawValue,
            coding: [CodableEnum].jsonDataArrayPrefsCoding
        ) var arrayDDefaulted: [CodableEnum] = [.one, .two]
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
        schema.arrayA = [.two, .two, .one]
        #expect(schema.arrayA == [.two, .two, .one])
        
        #expect(schema.arrayADefaulted == [.one, .two])
        
        schema.arrayADefaulted = [.two, .two, .one]
        #expect(schema.arrayADefaulted == [.two, .two, .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayA.rawValue) as? String)
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayADefaulted.rawValue) as? String)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func singleJSONData(schema: TestSchema) throws {
        schema.arrayB = [.two, .two, .one]
        #expect(schema.arrayB == [.two, .two, .one])
        
        #expect(schema.arrayBDefaulted == [.one, .two])
        
        schema.arrayBDefaulted = [.two, .two, .one]
        #expect(schema.arrayBDefaulted == [.two, .two, .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayB.rawValue) as? Data)
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayBDefaulted.rawValue) as? Data)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func arrayOfJSONStringElements(schema: TestSchema) throws {
        schema.arrayC = [.two, .two, .one]
        #expect(schema.arrayC == [.two, .two, .one])
        
        #expect(schema.arrayCDefaulted == [.one, .two])
        
        schema.arrayCDefaulted = [.two, .two, .one]
        #expect(schema.arrayCDefaulted == [.two, .two, .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayC.rawValue) as? [String])
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayCDefaulted.rawValue) as? [String])
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func arrayOfJSONDataElements(schema: TestSchema) throws {
        schema.arrayD = [.two, .two, .one]
        #expect(schema.arrayD == [.two, .two, .one])
        
        #expect(schema.arrayDDefaulted == [.one, .two])
        
        schema.arrayDDefaulted = [.two, .two, .one]
        #expect(schema.arrayDDefaulted == [.two, .two, .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayD.rawValue) as? [Data])
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayDDefaulted.rawValue) as? [Data])
    }
}
