//
//  MacroTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftPrefsCore
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// MARK: - Macro Implementation Testing

// swiftformat:disable indent

#if canImport(SwiftPrefsMacrosImplementation)

@testable import SwiftPrefsMacrosImplementation

final class PrefsSchemaMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "PrefsSchema": PrefsSchemaMacro.self
    ]
    
    func testPrefsSchemaMacro() {
        assertMacroExpansion(
            """
            @PrefsSchema final class Foo {
                var foo: Int?
            }
            """,
            expandedSource: """
            final class Foo {
                var foo: Int?
            
                @ObservationIgnored private let _$observationRegistrar = Observation.ObservationRegistrar()
            }
            
            extension Foo: PrefsSchema {
            }
            
            extension Foo: Observable {
                internal nonisolated func access<Member>(
                    keyPath: KeyPath<Foo, Member>
                ) {
                    _$observationRegistrar.access(self, keyPath: keyPath)
                }
            
                internal nonisolated func withMutation<Member, MutationResult>(
                    keyPath: KeyPath<Foo, Member>,
                    _ mutation: () throws -> MutationResult
                ) rethrows -> MutationResult {
                    try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
                }
            }
            """,
            macros: testMacros
        )
    }
}

final class AtomicPrefMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Pref": AtomicPrefMacro.self
    ]
    
    func testPrefMacro_KeyArgument_Optional() {
        assertMacroExpansion(
            """
            @Pref(key: "someInt") var foo: Int?
            """,
            expandedSource: """
            var foo: Int? {
                get {
                    _$observationRegistrar.access(self, keyPath: \\.foo)
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_foo == nil {
                            __PrefValue_foo = storage.value(forKey: __PrefCoding_foo)
                        }
                        return __PrefValue_foo
                    case .storageOnly:
                        return storage.value(forKey: __PrefCoding_foo)
                    }
                }
                set {
                    withMutation(keyPath: \\.foo) {
                        storage.setValue(forKey: __PrefCoding_foo, to: newValue)
                        if storageMode == .cachedReadStorageWrite {
                            __PrefValue_foo = newValue
                        }
                    }
                }
                _modify {
                    access(keyPath: \\.foo)
                    _$observationRegistrar.willSet(self, keyPath: \\.foo)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.foo)
                    }
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_foo == nil {
                            __PrefValue_foo = storage.value(forKey: __PrefCoding_foo)
                        }
                        yield &__PrefValue_foo
                        storage.setValue(forKey: __PrefCoding_foo, to: __PrefValue_foo)
                    case .storageOnly:
                        var val = storage.value(forKey: __PrefCoding_foo)
                        yield &val
                        storage.setValue(forKey: __PrefCoding_foo, to: val)
                    }
                }
            }
            
            private let __PrefCoding_foo = SwiftPrefsTypes.AnyAtomicPrefsKey<Int>(key: "someInt")
            
            private var __PrefValue_foo: Int?
            """,
            macros: testMacros
        )
    }
    
    func testPrefMacro_NoKeyArgument_Optional() {
        assertMacroExpansion(
            """
            @Pref var foo: Int?
            """,
            expandedSource: """
            var foo: Int? {
                get {
                    _$observationRegistrar.access(self, keyPath: \\.foo)
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_foo == nil {
                            __PrefValue_foo = storage.value(forKey: __PrefCoding_foo)
                        }
                        return __PrefValue_foo
                    case .storageOnly:
                        return storage.value(forKey: __PrefCoding_foo)
                    }
                }
                set {
                    withMutation(keyPath: \\.foo) {
                        storage.setValue(forKey: __PrefCoding_foo, to: newValue)
                        if storageMode == .cachedReadStorageWrite {
                            __PrefValue_foo = newValue
                        }
                    }
                }
                _modify {
                    access(keyPath: \\.foo)
                    _$observationRegistrar.willSet(self, keyPath: \\.foo)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.foo)
                    }
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_foo == nil {
                            __PrefValue_foo = storage.value(forKey: __PrefCoding_foo)
                        }
                        yield &__PrefValue_foo
                        storage.setValue(forKey: __PrefCoding_foo, to: __PrefValue_foo)
                    case .storageOnly:
                        var val = storage.value(forKey: __PrefCoding_foo)
                        yield &val
                        storage.setValue(forKey: __PrefCoding_foo, to: val)
                    }
                }
            }
            
            private let __PrefCoding_foo = SwiftPrefsTypes.AnyAtomicPrefsKey<Int>(key: "foo")
            
            private var __PrefValue_foo: Int?
            """,
            macros: testMacros
        )
    }
    
    func testPrefMacro_KeyArgument_DefaultValue() {
        assertMacroExpansion(
            """
            @Pref(key: KeyName.bar) var bar: String = "baz"
            """,
            expandedSource: """
            var bar: String {
                get {
                    _$observationRegistrar.access(self, keyPath: \\.bar)
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar)
                        }
                        return __PrefValue_bar ?? __PrefCoding_bar.defaultValue
                    case .storageOnly:
                        return storage.value(forKey: __PrefCoding_bar)
                    }
                }
                set {
                    withMutation(keyPath: \\.bar) {
                        storage.setValue(forKey: __PrefCoding_bar, to: newValue)
                        if storageMode == .cachedReadStorageWrite {
                            __PrefValue_bar = newValue
                        }
                    }
                }
                _modify {
                    access(keyPath: \\.bar)
                    _$observationRegistrar.willSet(self, keyPath: \\.bar)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.bar)
                    }
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar) ?? __PrefCoding_bar.defaultValue
                        }
                        yield &__PrefValue_bar!
                        storage.setValue(forKey: __PrefCoding_bar, to: __PrefValue_bar)
                    case .storageOnly:
                        var val = storage.value(forKey: __PrefCoding_bar)
                        yield &val
                        storage.setValue(forKey: __PrefCoding_bar, to: val)
                    }
                }
            }
            
            private let __PrefCoding_bar = SwiftPrefsTypes.AnyDefaultedAtomicPrefsKey<String>(key: KeyName.bar, defaultValue: "baz")
            
            private var __PrefValue_bar: String?
            """,
            macros: testMacros
        )
    }
    
    func testPrefMacro_NoKeyArgument_DefaultValue() {
        assertMacroExpansion(
            """
            @Pref var bar: String = "baz"
            """,
            expandedSource: """
            var bar: String {
                get {
                    _$observationRegistrar.access(self, keyPath: \\.bar)
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar)
                        }
                        return __PrefValue_bar ?? __PrefCoding_bar.defaultValue
                    case .storageOnly:
                        return storage.value(forKey: __PrefCoding_bar)
                    }
                }
                set {
                    withMutation(keyPath: \\.bar) {
                        storage.setValue(forKey: __PrefCoding_bar, to: newValue)
                        if storageMode == .cachedReadStorageWrite {
                            __PrefValue_bar = newValue
                        }
                    }
                }
                _modify {
                    access(keyPath: \\.bar)
                    _$observationRegistrar.willSet(self, keyPath: \\.bar)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.bar)
                    }
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar) ?? __PrefCoding_bar.defaultValue
                        }
                        yield &__PrefValue_bar!
                        storage.setValue(forKey: __PrefCoding_bar, to: __PrefValue_bar)
                    case .storageOnly:
                        var val = storage.value(forKey: __PrefCoding_bar)
                        yield &val
                        storage.setValue(forKey: __PrefCoding_bar, to: val)
                    }
                }
            }
            
            private let __PrefCoding_bar = SwiftPrefsTypes.AnyDefaultedAtomicPrefsKey<String>(key: "bar", defaultValue: "baz")
            
            private var __PrefValue_bar: String?
            """,
            macros: testMacros
        )
    }
}

final class CodingPrefMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Pref": CodingPrefMacro.self
    ]
    
    // TODO: Add unit tests
}

final class InlinePrefMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Pref": InlinePrefMacro.self
    ]
    
    func testPrefMacro_KeyArgument_DefaultValue() {
        assertMacroExpansion(
            """
            @Pref(key: KeyName.bar, encode: { MyType(rawValue: $0) }, decode: { $0.rawValue }) var bar: MyType = .foo
            """,
            expandedSource: """
            var bar: MyType {
                get {
                    _$observationRegistrar.access(self, keyPath: \\.bar)
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar)
                        }
                        return __PrefValue_bar ?? __PrefCoding_bar.defaultValue
                    case .storageOnly:
                        return storage.value(forKey: __PrefCoding_bar)
                    }
                }
                set {
                    withMutation(keyPath: \\.bar) {
                        storage.setValue(forKey: __PrefCoding_bar, to: newValue)
                        if storageMode == .cachedReadStorageWrite {
                            __PrefValue_bar = newValue
                        }
                    }
                }
                _modify {
                    access(keyPath: \\.bar)
                    _$observationRegistrar.willSet(self, keyPath: \\.bar)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.bar)
                    }
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar) ?? __PrefCoding_bar.defaultValue
                        }
                        yield &__PrefValue_bar!
                        storage.setValue(forKey: __PrefCoding_bar, to: __PrefValue_bar)
                    case .storageOnly:
                        var val = storage.value(forKey: __PrefCoding_bar)
                        yield &val
                        storage.setValue(forKey: __PrefCoding_bar, to: val)
                    }
                }
            }
            
            private let __PrefCoding_bar = SwiftPrefsTypes.AnyDefaultedPrefsKey(key: KeyName.bar, defaultValue: .foo, coding: SwiftPrefsTypes.PrefsCoding(encode: {
                        MyType(rawValue: $0)
                    }, decode: {
                        $0.rawValue
                    }))
            
            private var __PrefValue_bar: MyType?
            """,
            macros: testMacros
        )
    }
    
    func testPrefMacro_NoKeyArgument_DefaultValue() {
        assertMacroExpansion(
            """
            @Pref(encode: { MyType(rawValue: $0) }, decode: { $0.rawValue }) var bar: String = "baz"
            """,
            expandedSource: """
            var bar: String {
                get {
                    _$observationRegistrar.access(self, keyPath: \\.bar)
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar)
                        }
                        return __PrefValue_bar ?? __PrefCoding_bar.defaultValue
                    case .storageOnly:
                        return storage.value(forKey: __PrefCoding_bar)
                    }
                }
                set {
                    withMutation(keyPath: \\.bar) {
                        storage.setValue(forKey: __PrefCoding_bar, to: newValue)
                        if storageMode == .cachedReadStorageWrite {
                            __PrefValue_bar = newValue
                        }
                    }
                }
                _modify {
                    access(keyPath: \\.bar)
                    _$observationRegistrar.willSet(self, keyPath: \\.bar)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.bar)
                    }
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar) ?? __PrefCoding_bar.defaultValue
                        }
                        yield &__PrefValue_bar!
                        storage.setValue(forKey: __PrefCoding_bar, to: __PrefValue_bar)
                    case .storageOnly:
                        var val = storage.value(forKey: __PrefCoding_bar)
                        yield &val
                        storage.setValue(forKey: __PrefCoding_bar, to: val)
                    }
                }
            }
            
            private let __PrefCoding_bar = SwiftPrefsTypes.AnyDefaultedPrefsKey(key: "bar", defaultValue: "baz", coding: SwiftPrefsTypes.PrefsCoding(encode: {
                        MyType(rawValue: $0)
                    }, decode: {
                        $0.rawValue
                    }))
            
            private var __PrefValue_bar: String?
            """,
            macros: testMacros
        )
    }
}

final class RawRepresentablePrefMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "RawRepresentablePref": RawRepresentablePrefMacro.self
    ]
    
    // TODO: Add unit tests
}

final class JSONDataCodablePrefMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "JSONDataCodablePref": JSONDataCodablePrefMacro.self
    ]
    
    // TODO: Add unit tests
}

final class JSONStringCodablePrefMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "JSONStringCodablePref": JSONStringCodablePrefMacro.self
    ]
    
    // TODO: Add unit tests
}

#endif
