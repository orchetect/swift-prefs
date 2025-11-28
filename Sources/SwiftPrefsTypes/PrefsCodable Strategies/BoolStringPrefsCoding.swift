//
//  BoolStringPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Coding strategy for `Bool` using `String` as the encoded storage value (`true`/`false` or `yes`/`no`).
public struct BoolStringPrefsCoding: PrefsCodable {
    public let encodingStrategy: EncodingStrategy
    
    public init(encodingStrategy: EncodingStrategy) {
        self.encodingStrategy = encodingStrategy
    }
    
    public func encode(prefsValue: Bool) -> String? {
        switch encodingStrategy {
        case let .trueFalse(textCase):
            let text = prefsValue ? "true" : "false"
            return textCase.process(text)
            
        case let .yesNo(textCase):
            let text = prefsValue ? "yes" : "no"
            return textCase.process(text)
            
        case let .custom(true: trueValue, false: falseValue, caseInsensitive: _):
            return prefsValue ? trueValue : falseValue
        }
    }
    
    public func decode(prefsValue: String) -> Bool? {
        switch encodingStrategy {
        case .trueFalse, .yesNo:
            switch prefsValue.trimmingCharacters(in: .whitespacesAndNewlines) {
            case let v where v.caseInsensitiveCompare("true") == .orderedSame: true
            case let v where v.caseInsensitiveCompare("false") == .orderedSame: false
            case let v where v.caseInsensitiveCompare("yes") == .orderedSame: true
            case let v where v.caseInsensitiveCompare("no") == .orderedSame: false
            default: nil
            }
        case let .custom(true: trueValue, false: falseValue, caseInsensitive: isCaseInsensitive):
            if isCaseInsensitive {
                switch prefsValue.trimmingCharacters(in: .whitespacesAndNewlines) {
                case let v where v.caseInsensitiveCompare(trueValue) == .orderedSame: true
                case let v where v.caseInsensitiveCompare(falseValue) == .orderedSame: false
                default: nil
                }
            } else {
                switch prefsValue.trimmingCharacters(in: .whitespacesAndNewlines) {
                case trueValue: true
                case falseValue: false
                default: nil
                }
            }
        }
    }
}

extension BoolStringPrefsCoding {
    /// String encoding strategy for ``BoolStringPrefsCoding``.
    public enum EncodingStrategy: Equatable, Hashable, Sendable {
        /// True or False.
        case trueFalse(_ textCase: TextCase = .lowercase)
        
        /// Yes or No.
        case yesNo(_ textCase: TextCase = .lowercase)
        
        /// Custom string values for `true` and `false` states.
        case custom(true: String, false: String, caseInsensitive: Bool = true)
    }
}

extension BoolStringPrefsCoding.EncodingStrategy {
    public enum TextCase: Equatable, Hashable, Sendable {
        /// Capitalized text.
        case capitalized
        
        /// Lowercase text.
        case lowercase
        
        /// Uppercase text.
        case uppercase
        
        /// Process an input string based on the enumeration case.
        public func process(_ string: String) -> String {
            switch self {
            case .capitalized: string.capitalized
            case .lowercase: string.lowercased()
            case .uppercase: string.uppercased()
            }
        }
    }
}

// MARK: - Static Constructor

extension PrefsCodable where Self == BoolStringPrefsCoding {
    /// Coding strategy for `Bool` using `String` as the encoded storage value (`true`/`false` or `yes`/`no`).
    public static func boolAsString(
        _ encodingStrategy: BoolStringPrefsCoding.EncodingStrategy = .trueFalse(.lowercase)
    ) -> Self {
        BoolStringPrefsCoding(encodingStrategy: encodingStrategy)
    }
}

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue == Bool {
    /// Coding strategy for `Bool` using `String` as the encoded storage value (`true`/`false` or `yes`/`no`).
    public func boolAsString(
        _ encodingStrategy: BoolStringPrefsCoding.EncodingStrategy = .trueFalse(.lowercase)
    ) -> PrefsCodingTuple<Self, BoolStringPrefsCoding> {
        PrefsCodingTuple(self, BoolStringPrefsCoding(encodingStrategy: encodingStrategy))
    }
}
