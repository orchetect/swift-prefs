//
//  AtomicPrefMacro.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public struct AtomicPrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyAtomicPrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedAtomicPrefsKey"
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = false
}
