//
//  ISO8601StringDatePrefsCodingTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsCore
import Testing

@Suite
struct ISO8601StringDatePrefsCodingTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .storageOnly // important for unit tests in this file!
        
        // MARK: - Static Constructors
        
        @Pref(coding: .iso8601DateString) var date: Date?
    }
    
    // MARK: - Static Constructors
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func dateISO8601String_SetValue() async throws {
        let schema = TestSchema()
        
        let testDate = Date(timeIntervalSinceReferenceDate: 757_493_476)
        
        schema.date = testDate
        #expect(schema.storage.storageValue(forKey: "date") as String? == "2025-01-02T06:51:16Z")
        #expect(schema.date == testDate)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func dateISO8601String_SetStorageValue() async throws {
        let schema = TestSchema()
        
        let testDate = Date(timeIntervalSinceReferenceDate: 757_493_476)
        
        #expect(schema.date == nil)
        
        schema.storage.setStorageValue(forKey: "date", to: "2025-01-02T06:51:16Z")
        #expect(schema.date == testDate)
    }
}
