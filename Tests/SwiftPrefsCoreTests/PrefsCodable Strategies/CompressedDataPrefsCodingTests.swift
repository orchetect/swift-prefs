//
//  CompressedDataPrefsCodingTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsCore
import Testing

@Suite
struct CompressedDataPrefsCodingTests {
    struct MyType: Equatable, Codable {
        var id: Int
        var name: String
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .storageOnly // important for unit tests in this file!
        
        // MARK: - Static Constructors
        
        @Pref(coding: .compressedData(algorithm: .zlib)) var data: Data?
        
        // MARK: - Chaining Constructor
        
        @Pref(
            coding: MyType
                .jsonDataPrefsCoding
                .compressedData(algorithm: .zlib)
        ) var myTypeChained: MyType?
    }
    
    // MARK: - Static Constructors
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func data() throws {
        let schema = TestSchema()
        
        let testData = Data([0x01, 0x02, 0x03])
        
        schema.data = testData
        #expect(schema.storage.storageValue(forKey: "data") as Data? == Data([0x63, 0x64, 0x62, 0x06, 0x00]))
        #expect(schema.data == testData)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func myTypeChained() throws {
        let schema = TestSchema()
        
        let testType = MyType(id: 123, name: "foo")
        
        schema.myTypeChained = testType
        let getData: Data = try #require(schema.storage.storageValue(forKey: "myTypeChained"))
        // just check for non-empty content, we won't check actual content since it's not fully deterministic
        #expect(getData.count > 10)
        #expect(schema.myTypeChained == testType)
    }
}
