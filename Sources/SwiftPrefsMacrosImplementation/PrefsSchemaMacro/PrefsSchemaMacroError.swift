//
//  PrefsSchemaMacroError.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PrefsSchemaMacro {
    public enum PrefsSchemaMacroError: LocalizedError {
        case incorrectSyntax
        case mainActorNotSupported
        
        public var errorDescription: String? {
            switch self {
            case .incorrectSyntax:
                "Incorrect syntax."
            case .mainActorNotSupported:
                "@MainActor is only supported in Swift 6.2 or later (Xcode 26 or later)."
            }
        }
    }
}

extension PrefsSchemaMacro.PrefsSchemaMacroError: CustomStringConvertible {
    public var description: String { errorDescription ?? localizedDescription }
}
