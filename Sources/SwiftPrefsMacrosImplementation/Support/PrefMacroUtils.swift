//
//  PrefMacroUtils.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum PrefMacroUtils {
    static var moduleNamePrefix: String { "SwiftPrefsTypes." }
    
    static var privateCodingVarPrefix: String { "__PrefCoding_" }
    static var privateValueVarPrefix: String { "__PrefValue_" }
}

extension PrefMacroUtils {
    static func args(from node: AttributeSyntax) throws(PrefMacroError) -> (
        key: LabeledExprSyntax?,
        coding: LabeledExprSyntax?,
        encode: LabeledExprSyntax?,
        decode: LabeledExprSyntax?
    ) {
        guard node.arguments != nil else {
            // no `key:`, or subsequent `coding:` / `encode:`/`decode:`
            // we'll derive key name from variable name upon return.
            return (key: nil, coding: nil, encode: nil, decode: nil)
        }
        
        guard let args = node.arguments?.as(LabeledExprListSyntax.self)
        else {
            throw .incorrectSyntax
        }
        
        var remainingArgs = args
        
        func nextArg() throws(PrefMacroError) -> (LabeledExprSyntax, label: String)? {
            guard !remainingArgs.isEmpty else { return nil }
            let idx = remainingArgs.startIndex
            let arg = remainingArgs[idx]
            remainingArgs.remove(at: idx)
            
            guard let label = arg.label?.trimmedDescription else { throw .invalidArgumentLabel }
            return (arg, label)
        }
        
        var key: LabeledExprSyntax?
        var coding: LabeledExprSyntax?
        var encode: LabeledExprSyntax?
        var decode: LabeledExprSyntax?
        
        var tuple: (
            key: LabeledExprSyntax?,
            coding: LabeledExprSyntax?,
            encode: LabeledExprSyntax?,
            decode: LabeledExprSyntax?
        ) { (key, coding, encode, decode) }
        
        var currentArg: LabeledExprSyntax
        var currentArgLabel: String
        
        // arg could be `key:`, or `coding:`, or `encode:`
        guard let (a, l) = try nextArg() else {
            // no `key:`, or subsequent `coding:` / `encode:`/`decode:`
            // we'll derive key name from variable name upon return.
            return tuple
        }
        currentArg = a; currentArgLabel = l
        
        if currentArgLabel == "key" {
            key = currentArg
            
            // we can accept a `nil` literal as equivalent to the argument not being found (if it was defaulted to `nil`)
            if currentArg.expression.description == "nil" { key = nil }
            
            guard let (a, l) = try nextArg() else {
                // no subsequent `coding:` / `encode:`/`decode:`
                return tuple
            }
            currentArg = a; currentArgLabel = l
            currentArg = a; currentArgLabel = l
        }
        
        switch currentArgLabel {
        case "coding":
            coding = currentArg
            
            guard (try? nextArg()) == nil else {
                throw .tooManyArguments
            }
            
            return tuple
        case "encode":
            encode = currentArg
            
            guard let (a, l) = try nextArg() else {
                throw .missingCodingArgument
            }
            currentArg = a; currentArgLabel = l
            
            if currentArgLabel == "decode" {
                decode = currentArg
                
                guard (try? nextArg()) == nil else {
                    throw .tooManyArguments
                }
                
                return tuple
            } else {
                throw .incorrectSyntax
            }
        default:
            throw .incorrectSyntax
        }
    }
    
    static func varName(from declaration: VariableDeclSyntax) throws(PrefMacroError) -> IdentifierPatternSyntax {
        guard let val = declaration.bindings.first?.pattern
            .as(IdentifierPatternSyntax.self)
        else {
            throw .invalidVariableName
        }
        return val
    }
}

extension PrefMacroUtils {
    static func typeBinding(from declaration: VariableDeclSyntax) throws(PrefMacroError) -> TypeBinding {
        guard let val = declaration.bindings.first?.typeAnnotation?.type
        else {
            throw .missingOrInvalidTypeAnnotation
        }
        
        if let optionalTypeBinding = val.as(OptionalTypeSyntax.self) {
            return .optional(optionalTypeBinding.wrappedType)
        } else {
            return .nonOptional(val)
        }
    }
}

extension PrefMacroUtils {
    static func defaultValue(from declaration: VariableDeclSyntax) throws(PrefMacroError) -> ExprSyntax {
        guard let val = declaration.bindings.first?.initializer?.value
        else {
            throw .missingDefaultValue
        }
        return val
    }
}
