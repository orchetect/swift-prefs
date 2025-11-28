//
//  PrefMacro.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public protocol PrefMacro: AccessorMacro, PeerMacro {
    static var keyStructName: String { get }
    static var defaultedKeyStructName: String { get }
    static var hasCustomCoding: Bool { get }
    static var hasInlineCoding: Bool { get }
}

extension PrefMacro /* : AccessorMacro */ {
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
        let privateKeyVarName = "\(PrefMacroUtils.privateCodingVarPrefix)\(varName)"
        let privateValueVarName = "\(PrefMacroUtils.privateValueVarPrefix)\(varName)"
        
        let keyPath = #"\."# + varName.description
        
        let hasDefault = (try? PrefMacroUtils.defaultValue(from: varDec)) != nil
        
        return [
            """
            get {
                _$observationRegistrar.access(self, keyPath: \(raw: keyPath))
                switch storageMode {
                case .cachedReadStorageWrite:
                    if \(raw: privateValueVarName) == nil {
                        \(raw: privateValueVarName) = storage.value(forKey: \(raw: privateKeyVarName))
                    }
                    return \(raw: privateValueVarName)\(raw: hasDefault ? " ?? \(privateKeyVarName).defaultValue" : "")
                case .storageOnly:
                    return storage.value(forKey: \(raw: privateKeyVarName))
                }
            }
            """,
            """
            set {
                withMutation(keyPath: \(raw: keyPath)) {
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: newValue)
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
                        \(raw: privateValueVarName) = storage.value(forKey: \(raw: privateKeyVarName))\(raw: hasDefault ? " ?? \(privateKeyVarName).defaultValue" : "")
                    }
                    yield &\(raw: privateValueVarName)\(raw: hasDefault ? "!" : "")
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: \(raw: privateValueVarName))
                case .storageOnly:
                    var val = storage.value(forKey: \(raw: privateKeyVarName))
                    yield &val
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: val)
                }
            }
            """
        ]
    }
}

extension PrefMacro /* : PeerMacro */ {
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
        let privateKeyVarName = "\(PrefMacroUtils.privateCodingVarPrefix)\(varName)"
        let privateValueVarName = "\(PrefMacroUtils.privateValueVarPrefix)\(varName)"
        
        let (keyArg, codingArg, encodeArg, decodeArg) = try PrefMacroUtils.args(from: node)
        // use variable name as the key name if key was not supplied
        let keyName = keyArg?.expression.description ?? "\"\(varName)\""
        
        var customCodingDecl: String?
        if hasCustomCoding {
            guard let codingArg else {
                throw PrefMacroError.missingCodingArgument
            }
            customCodingDecl = codingArg.expression.description
        } else if hasInlineCoding {
            guard let encodeArg, let decodeArg else {
                throw PrefMacroError.missingCodingArgument
            }
            customCodingDecl = "\(PrefMacroUtils.moduleNamePrefix)PrefsCoding(encode: \(encodeArg.expression.description), decode: \(decodeArg.expression.description))"
        }
        
        let typeInfo = try TypeBindingInfo(
            for: Self.self,
            from: varDec,
            keyName: keyName,
            privateKeyVarName: privateKeyVarName,
            privateValueVarName: privateValueVarName,
            customCodingDecl: customCodingDecl
        )
        
        return [
            """
            \(raw: typeInfo.privateKeyVarDeclaration)
            """,
            """
            \(raw: typeInfo.privateValueVarDeclaration)
            """
        ]
    }
}
