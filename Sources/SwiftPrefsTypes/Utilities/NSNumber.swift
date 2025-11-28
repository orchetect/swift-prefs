//
//  NSNumber.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - objCTypeString

extension NSNumber {
    /// Returns `objCType` (Objective-C type encoding) as `String`.
    ///
    /// Possible strings are a subset of `NSValue`'s Objective-C type encodings.
    ///
    /// ```
    /// “c”, “C”, “s”, “S”, “i”, “I”, “l”, “L”, “q”, “Q”, “f”, and “d”.
    /// ```
    package var objCTypeString: String {
        String(cString: objCType)
    }
}

// MARK: - TypeEncoding

extension NSNumber {
    /// Objective-C type encoding for `NSNumber`.
    ///
    /// See: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    package enum TypeEncoding: String, Equatable, Hashable {
        case char = "c" // A char
        case int = "i" // An int
        case short = "s" // A short
        case long = "l" // A long, treated as a 32-bit quantity on 64-bit programs.
        case longLong = "q" // A long long
        case unsignedChar = "C" // An unsigned char
        case unsignedInt = "I" // An unsigned int
        case unsignedShort = "S" // An unsigned short
        case unsignedLong = "L" // An unsigned long
        case unsignedLongLong = "Q" // An unsigned long long
        case float = "f" // A float
        case double = "d" // A double
        case cBool = "B" // A C++ bool or a C99 _Bool
        case void = "v" // A void
        case characterString = "*" // A character string (char *)
        case object = "@" // An object (whether statically typed or typed id)
        case classObject = "#" // A class object (Class)
        case methodSelector = ":" // A method selector (SEL)
        case unknown
        
        init(value: NSNumber) {
            let objCTypeString = value.objCTypeString
            self = Self(rawValue: objCTypeString) ?? .unknown
        }
    }
    
    package var typeEncoding: TypeEncoding {
        TypeEncoding(value: self)
    }
}

// MARK: - SwiftNumberType

extension NSNumber {
    /// Swift concrete number type detection heuristic for `NSNumber`.
    package enum SwiftNumberType: Equatable, Hashable {
        case int_uInt_uInt32_uInt64_uInt16
        case int8_bool
        case uInt8_int16
        case double
        case float
        case unknown
        
        init(value: NSNumber) {
            let objCTypeString = value.objCTypeString
            self.init(objCType: objCTypeString)
        }
        
        init(objCType: String) {
            let typeEncoding = TypeEncoding(rawValue: objCType) ?? .unknown
            self.init(typeEncoding: typeEncoding)
        }
        
        init(typeEncoding: TypeEncoding) {
            // Swift Type  Encoding When Cast to NSNumber
            // ----------  ------------------------------
            //             c  s  i  q  d  f
            //             -  -  -  -  -  -
            // Int                  q
            // UInt                 q
            // Int8        c
            // UInt8          s
            // Int16          s
            // UInt16            i
            // Int32             i
            // UInt32               q
            // Int64                q
            // UInt64               q
            //
            // Double                  d
            // Float                      f
            //
            // Bool        c
            
            self = switch typeEncoding {
            case .char: // "c"
                .int8_bool
            case .short: // "s"
                .uInt8_int16
            case .longLong: // "q"
                .int_uInt_uInt32_uInt64_uInt16
            case .double: // "d"
                .double
            case .float: // "f"
                .float
            default:
                .unknown
            }
        }
    }
    
    package var potentialNumberType: SwiftNumberType {
        SwiftNumberType(value: self)
    }
}
