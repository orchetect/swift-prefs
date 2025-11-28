//
//  SwiftPrefsMacrosPlugin.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftCompilerPlugin)

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftPrefsMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PrefsSchemaMacro.self,
        AtomicPrefMacro.self,
        CodingPrefMacro.self,
        InlinePrefMacro.self,
        RawRepresentablePrefMacro.self,
        JSONDataCodablePrefMacro.self,
        JSONStringCodablePrefMacro.self,
        RawPrefMacro.self
    ]
}

#endif
