//
//  InlinePrefMacro.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public struct InlinePrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyPrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedPrefsKey"
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = true
}
