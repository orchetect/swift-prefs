//
//  ActorTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsCore
import Testing

/// Test `PrefsSchema` class with a `@Pref` member bound to `@MainActor`.
@Suite
struct MainActorMemberTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite
        
        @MainActor @Pref var foo: Int? // <-- can attach to individual properties
        @Pref var bar: String?
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func baseline() {
        let prefs = TestSchema()
        
        Task { @MainActor in prefs.foo = 1 } // <-- needs MainActor context
        prefs.bar = "a string"
    }
}

// @MainActor is only supported in Swift 6.2+ / Xcode 26+
#if compiler(>=6.2)
/// Test `PrefsSchema` class bound to `@MainActor`.
@Suite
struct MainActorBoundTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @MainActor @PrefsSchema public final class TestSchema {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite
        
        @Pref var foo: Int?
        @Pref var bar: String?
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @MainActor @Test
    func mainActor() {
        let prefs = TestSchema()
        
        prefs.foo = 1
    }
}
#endif
