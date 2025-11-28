//
//  CodablePrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A generic prefs value coding strategy that allows the encoding and decoding logic for a `Codable` type to be
/// conveniently supplied as closures, alleviating the need to create a new ``CodablePrefsCodable``-conforming type for
/// basic coding logic.
public struct CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>: CodablePrefsCodable
    where Value: Codable, Value: Sendable,
    StorageValue: PrefsStorageValue, StorageValue == Encoder.Output,
    Encoder: TopLevelEncoder, Encoder: Sendable, Encoder.Output: PrefsStorageValue,
    Decoder: TopLevelDecoder, Decoder: Sendable, Decoder.Input: PrefsStorageValue,
    Encoder.Output == Decoder.Input
{
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    public typealias Encoder = Encoder
    public typealias Decoder = Decoder
    let encoder: Encoder
    let decoder: Decoder
    
    public init(
        value: Value.Type,
        storageValue: StorageValue.Type,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) {
        self.encoder = encoder()
        self.decoder = decoder()
    }
    
    public func prefsEncoder() -> Encoder { encoder }
    public func prefsDecoder() -> Decoder { decoder }
}
