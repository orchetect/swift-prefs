//
//  URLStringPrefsCodingTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsCore
import Testing

@Suite
struct URLStringPrefsCodingTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite
        
        // MARK: - Static Constructors
        
        @Pref(coding: .urlString) var url: URL?
    }
    
    // MARK: - Static Constructors
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func urlString() async throws {
        let schema = TestSchema()
        
        let testURL = try #require(URL(string: "https://www.example.com"))
        
        schema.url = testURL
        #expect(schema.storage.storageValue(forKey: "url") as String? == "https://www.example.com")
        #expect(schema.url == testURL)
    }
}
