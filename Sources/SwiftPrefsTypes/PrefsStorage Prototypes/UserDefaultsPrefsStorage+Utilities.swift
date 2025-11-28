//
//  UserDefaultsPrefsStorage+Utilities.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaults {
    @inlinable
    package static func castAsPrefsStorageCompatible(value: Any) -> Any {
        // Note that underlying number format of NSNumber can't easily be determined
        // so the cleanest solution is to make NSNumber `PrefsStorageValue` and allow
        // the user to conditionally cast it as the number type they desire.
        
        switch value {
        // MARK: Atomic
        case let value as NSString:
            return value as String
        case let value as Bool where "\(type(of: value))" == "__NSCFBoolean":
            return value
        case let value as NSNumber:
            return value
        case let value as NSData:
            return value as Data
        case let value as NSDate:
            return value as Date
        // MARK: Arrays
        case let value as [NSString]:
            return value as [String]
        case let value as [Bool] where value.allSatisfy { "\(type(of: $0))" == "__NSCFBoolean" }:
            return value
        case let value as [NSNumber]:
            return value
        case let value as [NSData]:
            return value as [Data]
        case let value as [NSDate]:
            return value as [Date]
        case let value as [Any]:
            return value.map(castAsPrefsStorageCompatible(value:))
        // MARK: Dictionaries
        case let value as [NSString: NSString]:
            return value as [String: String]
        case let value as [NSString: Bool] where value.values.allSatisfy { "\(type(of: $0))" == "__NSCFBoolean" }:
            return value as [String: Bool]
        case let value as [NSString: NSNumber]:
            return value as [String: NSNumber]
        case let value as [NSString: NSData]:
            return value as [String: Data]
        case let value as [NSString: NSDate]:
            return value as [String: Date]
        case let value as [String: Any]:
            return value.mapValues(castAsPrefsStorageCompatible(value:))
        // MARK: Default
        default:
            assertionFailure("Unhandled UserDefaults pref storage value type: \(type(of: value))")
            return value
        }
    }
}
