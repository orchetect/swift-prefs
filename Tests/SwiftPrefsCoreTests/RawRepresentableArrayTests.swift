//
//  RawRepresentableArrayTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsCore
import Testing

@Suite(.serialized)
struct RawRepresentableArrayTests {
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
            case arrayA
            case arrayADefaulted
            case arrayB
            case arrayBDefaulted
        }
        
        @Pref(
            key: Key.arrayA.rawValue,
            coding: [StringEnum].rawRepresentableArrayPrefsCoding
        ) var arrayA: [StringEnum]?
        
        @Pref(
            key: Key.arrayADefaulted.rawValue,
            coding: [StringEnum].rawRepresentableArrayPrefsCoding
        ) var arrayADefaulted: [StringEnum] = [.one, .two]
        
        @Pref(
            key: Key.arrayB.rawValue,
            coding: [IntEnum].rawRepresentableArrayPrefsCoding
        ) var arrayB: [IntEnum]?
        
        @Pref(
            key: Key.arrayBDefaulted.rawValue,
            coding: [IntEnum].rawRepresentableArrayPrefsCoding
        ) var arrayBDefaulted: [IntEnum] = [.one, .two]
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
        schema.arrayA = [.two, .two, .one]
        #expect(schema.arrayA == [.two, .two, .one])
        
        #expect(schema.arrayADefaulted == [.one, .two])
        
        schema.arrayADefaulted = [.two, .two, .one]
        #expect(schema.arrayADefaulted == [.two, .two, .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayA.rawValue) as? [String])
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayADefaulted.rawValue) as? [String])
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func intRepresentable(schema: TestSchema) throws {
        schema.arrayB = [.two, .two, .one]
        #expect(schema.arrayB == [.two, .two, .one])
        
        #expect(schema.arrayBDefaulted == [.one, .two])
        
        schema.arrayBDefaulted = [.two, .two, .one]
        #expect(schema.arrayBDefaulted == [.two, .two, .one])
        
        // check underlying storage is as expected
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayB.rawValue) as? [Int])
        let _ = try #require(schema.storage.unsafeStorageValue(forKey: TestSchema.Key.arrayBDefaulted.rawValue) as? [Int])
    }
}
