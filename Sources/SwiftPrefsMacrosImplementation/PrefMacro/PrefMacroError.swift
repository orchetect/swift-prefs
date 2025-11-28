//
//  PrefMacroError.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum PrefMacroError: LocalizedError {
    case missingKeyArgument
    case missingCodingArgument
    case missingDecodeArgument
    case incorrectSyntax
    case invalidArgumentLabel
    case invalidKeyArgumentType
    case invalidVariableName
    case notVarDeclaration
    case missingDefaultValue
    case missingOrInvalidTypeAnnotation
    case modifiersNotAllowed
    case noDefaultValueAllowed
    case tooManyArguments
    
    public var errorDescription: String? {
        switch self {
        case .missingKeyArgument:
            "Missing value for key argument."
        case .missingCodingArgument:
            "Missing value for coding argument."
        case .missingDecodeArgument:
            "Missing value for decode argument."
        case .incorrectSyntax:
            "Incorrect syntax."
        case .invalidArgumentLabel:
            "Invalid argument label."
        case .invalidKeyArgumentType:
            "Invalid key argument type."
        case .invalidVariableName:
            "Invalid variable name."
        case .notVarDeclaration:
            "Must be a var declaration."
        case .missingDefaultValue:
            "Missing default value."
        case .missingOrInvalidTypeAnnotation:
            "Missing or invalid type annotation."
        case .modifiersNotAllowed:
            "Modifiers are not allowed."
        case .noDefaultValueAllowed:
            "No default value allowed."
        case .tooManyArguments:
            "Too many arguments."
        }
    }
}

extension PrefMacroError: CustomStringConvertible {
    public var description: String { errorDescription ?? localizedDescription }
}
