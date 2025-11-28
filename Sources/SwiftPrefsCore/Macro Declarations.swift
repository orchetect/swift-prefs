//
//  Macro Declarations.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsTypes

// MARK: - PrefsSchema (Class)

@attached(member, names: named(_$observationRegistrar))
@attached(extension, names: named(access), named(withMutation), conformances: Observable & PrefsSchema)
public macro PrefsSchema()
    = #externalMacro(module: "SwiftPrefsMacrosImplementation", type: "PrefsSchemaMacro")

// MARK: - Pref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref(key: String? = nil)
    = #externalMacro(module: "SwiftPrefsMacrosImplementation", type: "AtomicPrefMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref<Coding: PrefsCodable>(key: String? = nil, coding: Coding)
    = #externalMacro(module: "SwiftPrefsMacrosImplementation", type: "CodingPrefMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref<Value, StorageValue>(
    key: String? = nil,
    encode: (Value) -> StorageValue?,
    decode: (StorageValue) -> Value?
)
    = #externalMacro(module: "SwiftPrefsMacrosImplementation", type: "InlinePrefMacro")

// MARK: - RawRepresentablePref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro RawRepresentablePref(key: String? = nil)
    = #externalMacro(module: "SwiftPrefsMacrosImplementation", type: "RawRepresentablePrefMacro")

// MARK: - JSONDataCodablePref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro JSONDataCodablePref(key: String? = nil)
    = #externalMacro(module: "SwiftPrefsMacrosImplementation", type: "JSONDataCodablePrefMacro")

// MARK: - JSONStringCodablePref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro JSONStringCodablePref(key: String? = nil)
    = #externalMacro(module: "SwiftPrefsMacrosImplementation", type: "JSONStringCodablePrefMacro")

// MARK: - RawPref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefValue_))
public macro RawPref(key: String? = nil)
    = #externalMacro(module: "SwiftPrefsMacrosImplementation", type: "RawPrefMacro")
