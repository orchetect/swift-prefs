//
//  Internal Types.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum TypeBinding {
    case nonOptional(TypeSyntax)
    case optional(TypeSyntax)
    
    var isOptional: Bool {
        switch self {
        case .nonOptional: false
        case .optional: true
        }
    }
    
    var description: String {
        switch self {
        case let .nonOptional(typeSyntax):
            typeSyntax.trimmedDescription
        case let .optional(typeSyntax):
            typeSyntax.trimmedDescription
        }
    }
}

struct TypeBindingInfo {
    let isOptional: Bool
    let typeName: String
    let keyAndCodingStructName: String
    let keyAndCodingStructDeclaration: String
    let privateKeyVarDeclaration: String
    let privateValueVarDeclaration: String
    
    init(
        for macro: PrefMacro.Type,
        from declaration: some DeclSyntaxProtocol,
        keyName: String,
        privateKeyVarName: String,
        privateValueVarName: String
    ) throws {
        guard let varDec = declaration.as(VariableDeclSyntax.self)
        else {
            throw PrefMacroError.incorrectSyntax
        }
        try self.init(
            for: macro,
            from: varDec,
            keyName: keyName,
            privateKeyVarName: privateKeyVarName,
            privateValueVarName: privateValueVarName
        )
    }
    
    init(
        for macro: PrefMacro.Type,
        from varDec: VariableDeclSyntax,
        keyName: String,
        privateKeyVarName: String,
        privateValueVarName: String,
        customCodingDecl: String?
    ) throws {
        let typeBinding = try PrefMacroUtils.typeBinding(from: varDec)
        typeName = typeBinding.description
        
        let useCustomCodingDecl = macro.hasCustomCoding || macro.hasInlineCoding
        
        isOptional = typeBinding.isOptional
        if isOptional {
            // must not have a default value
            guard (try? PrefMacroUtils.defaultValue(from: varDec)) == nil else {
                throw PrefMacroError.noDefaultValueAllowed
            }
            keyAndCodingStructName = "\(PrefMacroUtils.moduleNamePrefix)\(macro.keyStructName)\(useCustomCodingDecl ? "" : "<\(typeName)>")"
            keyAndCodingStructDeclaration = keyAndCodingStructName +
                "(key: \(keyName)\(useCustomCodingDecl ? ", coding: \(customCodingDecl ?? "nil")" : ""))"
            privateKeyVarDeclaration = "private let \(privateKeyVarName) = \(keyAndCodingStructDeclaration)"
            privateValueVarDeclaration = "private var \(privateValueVarName): \(typeName)?"
        } else {
            // must have a default value
            let defaultValue = try PrefMacroUtils.defaultValue(from: varDec)
            keyAndCodingStructName =
                "\(PrefMacroUtils.moduleNamePrefix)\(macro.defaultedKeyStructName)\(useCustomCodingDecl ? "" : "<\(typeName)>")"
            keyAndCodingStructDeclaration = keyAndCodingStructName +
                "(key: \(keyName), defaultValue: \(defaultValue)\(useCustomCodingDecl ? ", coding: \(customCodingDecl ?? "nil")" : ""))"
            privateKeyVarDeclaration = "private let \(privateKeyVarName) = \(keyAndCodingStructDeclaration)"
            privateValueVarDeclaration = "private var \(privateValueVarName): \(typeName)?"
        }
    }
}
