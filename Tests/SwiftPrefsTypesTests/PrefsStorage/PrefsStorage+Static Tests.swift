//
//  PrefsStorage+Static Tests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsTypes
import Testing

@Suite struct PrefsStorageStaticTests {
    /// No logic testing, just ensure compiler is happy with our syntax sugar.
    @Test
    func varSyntax() {
        let _: PrefsStorage = AnyPrefsStorage(.dictionary)
        let _: PrefsStorage = AnyPrefsStorage(.dictionary(root: [:]))
        let _: PrefsStorage = AnyPrefsStorage(.userDefaults)
        let _: PrefsStorage = AnyPrefsStorage(.userDefaults(suite: .standard))
        
        let _: PrefsStorage = DictionaryPrefsStorage()
        let _: PrefsStorage = UserDefaultsPrefsStorage()
        
        let _: PrefsStorage = .dictionary
        let _: PrefsStorage = .dictionary(root: [:])
        let _: PrefsStorage = .userDefaults
        let _: PrefsStorage = .userDefaults(suite: .standard)
    }
    
    /// No logic testing, just ensure compiler is happy with our syntax sugar.
    @Test
    func anySyntax() {
        func foo(_ storage: any PrefsStorage) { }
        
        foo(AnyPrefsStorage(.dictionary))
        foo(AnyPrefsStorage(.dictionary(root: [:])))
        foo(AnyPrefsStorage(.userDefaults))
        foo(AnyPrefsStorage(.userDefaults(suite: .standard)))
        
        foo(DictionaryPrefsStorage())
        foo(UserDefaultsPrefsStorage())
        
        foo(.dictionary)
        foo(.dictionary(root: [:]))
        foo(.userDefaults)
        foo(.userDefaults(suite: .standard))
    }
    
    /// No logic testing, just ensure compiler is happy with our syntax sugar.
    @Test
    func someSyntax() {
        func foo(_ storage: some PrefsStorage) { }
        
        foo(AnyPrefsStorage(.dictionary))
        foo(AnyPrefsStorage(.dictionary(root: [:])))
        foo(AnyPrefsStorage(.userDefaults))
        foo(AnyPrefsStorage(.userDefaults(suite: .standard)))
        
        foo(DictionaryPrefsStorage())
        foo(UserDefaultsPrefsStorage())
        
        // doesn't work. huh?
        foo(.dictionary)
        foo(.dictionary(root: [:]))
        foo(.userDefaults)
        foo(.userDefaults(suite: .standard))
    }
}
