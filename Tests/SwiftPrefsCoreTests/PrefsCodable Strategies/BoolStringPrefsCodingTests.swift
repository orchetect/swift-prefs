//
//  BoolStringPrefsCodingTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftPrefsCore
import Testing

@Suite
struct BoolStringPrefsCodingTests {
    enum MyType: RawRepresentable {
        case yes
        case no
        
        init?(rawValue: Bool) {
            self = rawValue ? .yes : .no
        }
        
        var rawValue: Bool {
            switch self {
            case .yes: true
            case .no: false
            }
        }
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .storageOnly // important for unit tests in this file!
        
        // MARK: - Static Constructors
        
        @Pref(coding: .boolAsString(.trueFalse(.capitalized))) var boolStringTrueFalseCapitalized: Bool?
        @Pref(coding: .boolAsString(.trueFalse(.lowercase))) var boolStringTrueFalseLowercase: Bool?
        @Pref(coding: .boolAsString(.trueFalse(.uppercase))) var boolStringTrueFalseUppercase: Bool?
        
        @Pref(coding: .boolAsString(.yesNo(.uppercase))) var boolStringYesNoUppercase: Bool?
        
        @Pref(coding: .boolAsString(.custom(true: "Oui", false: "Non", caseInsensitive: true)))
        var boolStringCustomCaseInsensitive: Bool?
        
        @Pref(coding: .boolAsString(.custom(true: "Oui", false: "Non", caseInsensitive: false)))
        var boolStringCustomNonCaseInsensitive: Bool?
        
        // MARK: - Chaining Constructor
        
        @Pref(
            coding: MyType
                .rawRepresentablePrefsCoding
                .boolAsString() /* defaults to true/false (lowercase) */
        ) var myTypeBoolStringChained: MyType?
    }
    
    // MARK: - Static Constructors
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolStringTrueFalseCapitalized() {
        let schema = TestSchema()
        
        schema.boolStringTrueFalseCapitalized = true
        #expect(schema.storage.storageValue(forKey: "boolStringTrueFalseCapitalized") as String? == "True")
        #expect(schema.boolStringTrueFalseCapitalized == true)
        
        schema.boolStringTrueFalseCapitalized = false
        #expect(schema.storage.storageValue(forKey: "boolStringTrueFalseCapitalized") as String? == "False")
        #expect(schema.boolStringTrueFalseCapitalized == false)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolStringTrueFalseLowercase() {
        let schema = TestSchema()
        
        schema.boolStringTrueFalseLowercase = true
        #expect(schema.storage.storageValue(forKey: "boolStringTrueFalseLowercase") as String? == "true")
        #expect(schema.boolStringTrueFalseLowercase == true)
        
        schema.boolStringTrueFalseLowercase = false
        #expect(schema.storage.storageValue(forKey: "boolStringTrueFalseLowercase") as String? == "false")
        #expect(schema.boolStringTrueFalseLowercase == false)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolStringTrueFalseUppercase() {
        let schema = TestSchema()
        
        schema.boolStringTrueFalseUppercase = true
        #expect(schema.storage.storageValue(forKey: "boolStringTrueFalseUppercase") as String? == "TRUE")
        #expect(schema.boolStringTrueFalseUppercase == true)
        
        schema.boolStringTrueFalseUppercase = false
        #expect(schema.storage.storageValue(forKey: "boolStringTrueFalseUppercase") as String? == "FALSE")
        #expect(schema.boolStringTrueFalseUppercase == false)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func spotCheckDecoding() {
        let schema = TestSchema()
        
        // spot-check alternative storage values
        
        schema.storage.setStorageValue(forKey: "boolStringTrueFalseUppercase", to: "true")
        #expect(schema.boolStringTrueFalseUppercase == true)
        
        schema.storage.setStorageValue(forKey: "boolStringTrueFalseUppercase", to: "fAlsE")
        #expect(schema.boolStringTrueFalseUppercase == false)
        
        schema.storage.setStorageValue(forKey: "boolStringTrueFalseUppercase", to: "yEs")
        #expect(schema.boolStringTrueFalseUppercase == true)
        
        schema.storage.setStorageValue(forKey: "boolStringTrueFalseUppercase", to: "nO")
        #expect(schema.boolStringTrueFalseUppercase == false)
        
        schema.storage.setStorageValue(forKey: "boolStringTrueFalseUppercase", to: "foobar")
        #expect(schema.boolStringTrueFalseUppercase == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolStringCustomCaseInsensitive() {
        let schema = TestSchema()
        
        schema.boolStringCustomCaseInsensitive = true
        #expect(schema.storage.storageValue(forKey: "boolStringCustomCaseInsensitive") as String? == "Oui")
        #expect(schema.boolStringCustomCaseInsensitive == true)
        
        schema.boolStringCustomCaseInsensitive = false
        #expect(schema.storage.storageValue(forKey: "boolStringCustomCaseInsensitive") as String? == "Non")
        #expect(schema.boolStringCustomCaseInsensitive == false)
        
        schema.storage.setStorageValue(forKey: "boolStringCustomCaseInsensitive", to: "oui")
        #expect(schema.boolStringCustomCaseInsensitive == true)
        
        schema.storage.setStorageValue(forKey: "boolStringCustomCaseInsensitive", to: "non")
        #expect(schema.boolStringCustomCaseInsensitive == false)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolStringCustomNonCaseInsensitive() {
        let schema = TestSchema()
        
        schema.boolStringCustomNonCaseInsensitive = true
        #expect(schema.storage.storageValue(forKey: "boolStringCustomNonCaseInsensitive") as String? == "Oui")
        #expect(schema.boolStringCustomNonCaseInsensitive == true)
        
        schema.boolStringCustomNonCaseInsensitive = false
        #expect(schema.storage.storageValue(forKey: "boolStringCustomNonCaseInsensitive") as String? == "Non")
        #expect(schema.boolStringCustomNonCaseInsensitive == false)
        
        schema.storage.setStorageValue(forKey: "boolStringCustomNonCaseInsensitive", to: "oui")
        #expect(schema.boolStringCustomNonCaseInsensitive == nil)
        
        schema.storage.setStorageValue(forKey: "boolStringCustomNonCaseInsensitive", to: "non")
        #expect(schema.boolStringCustomNonCaseInsensitive == nil)
    }
    
    // MARK: - Chaining Constructor
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func myTypeBoolStringChained() {
        let schema = TestSchema()
        
        schema.myTypeBoolStringChained = .yes
        #expect(schema.storage.storageValue(forKey: "myTypeBoolStringChained") as String? == "true")
        #expect(schema.myTypeBoolStringChained == .yes)
        
        schema.myTypeBoolStringChained = .no
        #expect(schema.storage.storageValue(forKey: "myTypeBoolStringChained") as String? == "false")
        #expect(schema.myTypeBoolStringChained == .no)
        
        schema.storage.setStorageValue(forKey: "myTypeBoolStringChained", to: "foobar")
        #expect(schema.myTypeBoolStringChained == nil)
    }
}
