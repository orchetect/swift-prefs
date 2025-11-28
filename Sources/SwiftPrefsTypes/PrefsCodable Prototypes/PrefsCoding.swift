//
//  PrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// A generic prefs value coding strategy that allows the encoding and decoding logic to be conveniently supplied as
/// closures, alleviating the need to create a new ``PrefsCodable``-conforming type for basic coding logic.
public struct PrefsCoding<Value, StorageValue>: PrefsCodable
    where Value: Sendable, StorageValue: PrefsStorageValue
{
    let encodeBlock: @Sendable (Value) -> StorageValue?
    let decodeBlock: @Sendable (StorageValue) -> Value?
    
    public init(
        encode: @escaping @Sendable (Value) -> StorageValue?,
        decode: @escaping @Sendable (StorageValue) -> Value?
    ) {
        encodeBlock = encode
        decodeBlock = decode
    }
    
    public func decode(prefsValue: StorageValue) -> Value? {
        decodeBlock(prefsValue)
    }
    
    public func encode(prefsValue: Value) -> StorageValue? {
        encodeBlock(prefsValue)
    }
}
