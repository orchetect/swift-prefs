//
//  RawPrefMacro.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct RawPrefMacro: PrefMacro, AccessorMacro, PeerMacro {
    public static let keyStructName: String = "" // not used
    public static let defaultedKeyStructName: String = "" // not used
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = false
}

extension RawPrefMacro /* : AccessorMacro */ {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let varDec = declaration.as(VariableDeclSyntax.self)
        else {
            throw PrefMacroError.incorrectSyntax
        }
        
        guard varDec.bindingSpecifier.tokenKind == .keyword(.var) else {
            throw PrefMacroError.notVarDeclaration
        }
        
        let varName = try PrefMacroUtils.varName(from: varDec)
        let privateValueVarName = "\(PrefMacroUtils.privateValueVarPrefix)\(varName)"
        
        let keyPath = #"\."# + varName.description
        
        let defaultValue = try? PrefMacroUtils.defaultValue(from: varDec)
        
        let (keyArg, _ /* codingArg */, _ /* encodeArg */, _ /* decodeArg */) = try PrefMacroUtils.args(from: node)
        // use variable name as the key name if key was not supplied
        let keyName = keyArg?.expression.description ?? "\"\(varName)\""
        
        let typeInfo = try TypeBindingInfo(
            for: Self.self,
            from: varDec,
            keyName: keyName,
            privateKeyVarName: "", // not used
            privateValueVarName: privateValueVarName,
            customCodingDecl: "" // not used
        )
        
        let typeName = typeInfo.typeName
        // let optionalTypeName = typeInfo.typeName + (typeInfo.isOptional ? "?" : "")
        
        return [
            """
            get {
                _$observationRegistrar.access(self, keyPath: \(raw: keyPath))
                switch storageMode {
                case .cachedReadStorageWrite:
                    if \(raw: privateValueVarName) == nil {
                        \(raw: privateValueVarName) = storage.unsafeStorageValue(forKey: \(raw: keyName)) as? \(raw: typeName)
                    }
                    return \(raw: privateValueVarName)\(raw: defaultValue != nil ? " ?? \(defaultValue!)" : "")
                case .storageOnly: 
                    return (storage.unsafeStorageValue(forKey: \(raw: keyName)) as? \(raw: typeName))\(raw: defaultValue != nil ? " ?? \(defaultValue!)" : "")
                }
            }
            """,
            """
            set {
                withMutation(keyPath: \(raw: keyPath)) {
                    storage.setUnsafeStorageValue(forKey: \(raw: keyName), to: newValue)
                    if storageMode == .cachedReadStorageWrite {
                        \(raw: privateValueVarName) = newValue
                    }
                }
            }
            """,
            """
            _modify {
                access(keyPath: \(raw: keyPath))
                _$observationRegistrar.willSet(self, keyPath: \(raw: keyPath))
                defer {
                    _$observationRegistrar.didSet(self, keyPath: \(raw: keyPath))
                }
                switch storageMode {
                case .cachedReadStorageWrite:
                    if \(raw: privateValueVarName) == nil {
                        \(raw: privateValueVarName) = (storage.unsafeStorageValue(forKey: \(raw: keyName)) as? \(raw: typeName))\(raw: defaultValue != nil ? " ?? \(defaultValue!)" : "")
                    }
                    yield &\(raw: privateValueVarName)\(raw: defaultValue != nil ? "!" : "")
                    storage.setUnsafeStorageValue(forKey: \(raw: keyName), to: \(raw: privateValueVarName))
                case .storageOnly:
                    var val = (storage.unsafeStorageValue(forKey: \(raw: keyName)) as? \(raw: typeName))\(raw: defaultValue != nil ? " ?? \(defaultValue!)" : "")
                    yield &val
                    storage.setUnsafeStorageValue(forKey: \(raw: keyName), to: val)
                }
            }
            """
        ]
    }
}

extension RawPrefMacro /* : PeerMacro */ {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let varDec = declaration.as(VariableDeclSyntax.self)
        else {
            throw PrefMacroError.incorrectSyntax
        }
        
        let varName = try PrefMacroUtils.varName(from: varDec).description
        let privateValueVarName = "\(PrefMacroUtils.privateValueVarPrefix)\(varName)"
        
        let (keyArg, _ /* codingArg */, _ /* encodeArg */, _ /* decodeArg */) = try PrefMacroUtils.args(from: node)
        // use variable name as the key name if key was not supplied
        let keyName = keyArg?.expression.description ?? "\"\(varName)\""
        
        let typeInfo = try TypeBindingInfo(
            for: Self.self,
            from: varDec,
            keyName: keyName,
            privateKeyVarName: "", // not used
            privateValueVarName: privateValueVarName,
            customCodingDecl: "" // not used
        )
        
        return [
            """
            \(raw: typeInfo.privateValueVarDeclaration)
            """
        ]
    }
}
