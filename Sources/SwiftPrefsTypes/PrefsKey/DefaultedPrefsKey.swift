//
//  DefaultedPrefsKey.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public protocol DefaultedPrefsKey: PrefsKey {
    var defaultValue: Value { get }
}

extension DefaultedPrefsKey {
    public func decodeDefaulted(_ storageValue: StorageValue?) -> Value {
        decode(storageValue) ?? defaultValue
    }
}
