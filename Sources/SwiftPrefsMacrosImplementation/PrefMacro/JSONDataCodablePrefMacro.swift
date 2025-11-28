//
//  JSONDataCodablePrefMacro.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public struct JSONDataCodablePrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyJSONDataCodablePrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedJSONDataCodablePrefsKey"
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = false
}
