//
//  PrefsSchemaMacro.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct PrefsSchemaMacro { }

extension PrefsSchemaMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        [
            """
            @ObservationIgnored private let _$observationRegistrar = Observation.ObservationRegistrar()
            """
        ]
    }
}

extension PrefsSchemaMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard let classDec = declaration.as(ClassDeclSyntax.self)
        else {
            throw PrefMacroError.incorrectSyntax
        }
        // - `classDec.attributes` includes all leading modifiers like @available(), @MainActor, as well as the macro @PrefsSchema
        // - `classDec.modifiers` includes things like "public" and "final" but not actors like "@MainActor"
        // - `classDec.leadingTrivia` does not include actors like `@MainActor`
        let attributes = classDec
            .attributes
            .children(viewMode: .fixedUp)
            .map(\.trimmedDescription) // .kind == attribute for all
        
        let isMainActor = attributes.contains("@MainActor")
        
        #if compiler(<6.2)
        guard !isMainActor else {
            throw PrefsSchemaMacroError.mainActorNotSupported
        }
        #endif
        
        let prefsSchemaExtension = try ExtensionDeclSyntax(
            "extension \(type.trimmed): \(raw: isMainActor ? "@MainActor " : "")PrefsSchema { }"
        )
        let observableExtension = try ExtensionDeclSyntax(
            """
            extension \(type.trimmed): Observable {
                internal nonisolated func access<Member>(
                    keyPath: KeyPath<\(type.trimmed), Member>
                ) {
                    _$observationRegistrar.access(self, keyPath: keyPath)
                }
            
                internal nonisolated func withMutation<Member, MutationResult>(
                    keyPath: KeyPath<\(type.trimmed), Member>,
                    _ mutation: () throws -> MutationResult
                ) rethrows -> MutationResult {
                    try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
                }
            }
            """
        )
        
        return [prefsSchemaExtension, observableExtension]
    }
}
