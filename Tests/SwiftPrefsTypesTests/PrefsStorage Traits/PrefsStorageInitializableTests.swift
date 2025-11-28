//
//  PrefsStorageInitializableTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsTypes
import Testing

/// Test prefs storage inits for PList and JSON.
@Suite(.serialized)
struct PrefsStorageInitializableTests {
    static let domain = "com.orchetect.swift-prefs.\(type(of: Self.self))"
    
    typealias StorageBackend = PrefsStorage & PrefsStorageInitializable
    static var storageBackends: [any StorageBackend.Type] {
        [
            DictionaryPrefsStorage.self
            // (`UserDefaultsPrefsStorage` does not conform to the protocol)
        ]
    }
    
    typealias Key1 = TestContent.Basic.Root.Key1
    typealias Key2 = TestContent.Basic.Root.Key2
    typealias Key3 = TestContent.Basic.Root.Key3
    typealias Key4 = TestContent.Basic.Root.Key4
    typealias Key5 = TestContent.Basic.Root.Key5
    typealias Key6 = TestContent.Basic.Root.Key6
    typealias Key7 = TestContent.Basic.Root.Key7
    typealias Key8 = TestContent.Basic.Root.Key8
    typealias Key9 = TestContent.Basic.Root.Key9
    typealias Key10 = TestContent.Basic.Root.Key10
    typealias Key11 = TestContent.Basic.Root.Key11
    
    // MARK: - JSON Tests
    
    @Test(arguments: Self.storageBackends)
    func initJSONData(storageType: any PrefsStorageInitializable.Type) async throws {
        let data = try #require(TestContent.Basic.jsonString.data(using: .utf8))
        let storage = try storageType.init(
            from: data,
            format: .json(strategy: TestContent.Basic.JSONPrefsStorageImportStrategy())
        )
        
        try await TestContent.Basic.checkContent(in: storage)
    }
    
    @Test(arguments: Self.storageBackends)
    func initJSONString(storageType: any PrefsStorageInitializable.Type) async throws {
        let storage = try storageType.init(
            from: TestContent.Basic.jsonString,
            format: .json(strategy: TestContent.Basic.JSONPrefsStorageImportStrategy())
        )
        
        try await TestContent.Basic.checkContent(in: storage)
    }
    
    // MARK: - PList Tests
    
    @Test(arguments: Self.storageBackends)
    func initPListData(storageType: any PrefsStorageInitializable.Type) async throws {
        let data = try #require(TestContent.Basic.plistString.data(using: .utf8))
        let storage = try storageType.init(from: data, format: .plist())
        
        try await TestContent.Basic.checkContent(in: storage)
    }
    
    @Test(arguments: Self.storageBackends)
    func initPListString(storageType: any PrefsStorageInitializable.Type) async throws {
        let storage = try storageType.init(from: TestContent.Basic.plistString, format: .plist())
        
        try await TestContent.Basic.checkContent(in: storage)
    }
}
