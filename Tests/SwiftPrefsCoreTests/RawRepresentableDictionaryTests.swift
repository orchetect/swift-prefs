//
//  RawRepresentableDictionaryTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsCore
import Testing

@Suite(.serialized)
struct RawRepresentableDictionaryTests {
    static let domain = "com.orchetect.swift-prefs.\(type(of: Self.self))"
    
    static var suite: UserDefaults {
        UserDefaults(suiteName: domain)!
    }
    
    enum StringEnum: String, RawRepresentable {
        case one
        case two
    }
    
    enum IntEnum: Int, RawRepresentable {
        case one = 1
        case two = 2
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
        }
        
        @Pref(
            key: Key.dictA.rawValue,
            coding: [String: StringEnum].rawRepresentableDictionaryPrefsCoding
        ) var dictA: [String: StringEnum]?
        
        @Pref(
            key: Key.dictADefaulted.rawValue,
            coding: [String: StringEnum].rawRepresentableDictionaryPrefsCoding
        ) var dictADefaulted: [String: StringEnum] = ["a": .one, "b": .two]
        
        @Pref(
            key: Key.dictB.rawValue,
            coding: [String: IntEnum].rawRepresentableDictionaryPrefsCoding
        ) var dictB: [String: IntEnum]?
        
        @Pref(
            key: Key.dictBDefaulted.rawValue,
            coding: [String: IntEnum].rawRepresentableDictionaryPrefsCoding
        ) var dictBDefaulted: [String: IntEnum] = ["a": .one, "b": .two]
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
    func stringRepresentable(schema: TestSchema) throws {
        schema.dictA = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictA == ["a": .two, "b": .two, "c": .one])
        
        #expect(schema.dictADefaulted == ["a": .one, "b": .two])
        
        schema.dictADefaulted = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictADefaulted == ["a": .two, "b": .two, "c": .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictA.rawValue) as? [String: String])
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictADefaulted.rawValue) as? [String: String])
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func intRepresentable(schema: TestSchema) throws {
        schema.dictB = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictB == ["a": .two, "b": .two, "c": .one])
        
        #expect(schema.dictBDefaulted == ["a": .one, "b": .two])
        
        schema.dictBDefaulted = ["a": .two, "b": .two, "c": .one]
        #expect(schema.dictBDefaulted == ["a": .two, "b": .two, "c": .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictB.rawValue) as? [String: Int])
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.dictBDefaulted.rawValue) as? [String: Int])
    }
}
