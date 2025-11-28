//
//  PrefsKey.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public protocol PrefsKey where Self: Sendable, Coding.Value == Value, Coding.StorageValue == StorageValue {
    associatedtype Value: Sendable
    associatedtype StorageValue: PrefsStorageValue
    associatedtype Coding: PrefsCodable
    
    var key: String { get }
    var coding: Coding { get }
    func encode(_ value: Value) -> StorageValue?
    func decode(_ storageValue: StorageValue) -> Value?
}

extension PrefsKey {
    public func encode(_ value: Value?) -> StorageValue? {
        guard let value else { return nil }
        return encode(value)
    }

    public func decode(_ storageValue: StorageValue?) -> Value? {
        guard let storageValue else { return nil }
        return decode(storageValue)
    }
}

extension PrefsKey where Value == StorageValue {
    public func encode(_ value: Value) -> StorageValue? { value }
    public func decode(_ storageValue: StorageValue) -> Value? { storageValue }
}

extension PrefsKey {
    public func encode(_ value: Value) -> StorageValue? {
        coding.encode(prefsValue: value)
    }

    public func decode(_ storageValue: StorageValue) -> Value? {
        coding.decode(prefsValue: storageValue)
    }
}
