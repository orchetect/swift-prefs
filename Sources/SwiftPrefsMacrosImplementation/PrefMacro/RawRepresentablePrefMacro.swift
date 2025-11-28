//
//  RawRepresentablePrefMacro.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public struct RawRepresentablePrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyRawRepresentablePrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedRawRepresentablePrefsKey"
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = false
}
