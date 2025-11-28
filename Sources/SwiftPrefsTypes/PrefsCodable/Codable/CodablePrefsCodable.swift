//
//  CodablePrefsCodable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw storage.
///
/// > Tip:
/// >
/// > It is suggested that if multiple `Codable` types that stored in prefs storage use the same
/// > underlying encoder/decoder, that you create a protocol that inherits from ``CodablePrefsCodable``
/// > for all non-defaulted `Codable` prefs and then implement `prefEncoder()` and `prefDecoder()` to return
/// > the same instances. These types can then adopt this new protocol.
public protocol CodablePrefsCodable<Encoder, Decoder>: PrefsCodable
    where Value: Codable
{
    associatedtype Encoder: TopLevelEncoder
    associatedtype Decoder: TopLevelDecoder
    
    /// Return a new instance of the encoder used to encode the type for prefs storage.
    func prefsEncoder() -> Encoder
    
    /// Return a new instance of the decoder used to decode the type from prefs storage.
    func prefsDecoder() -> Decoder
}

extension CodablePrefsCodable where StorageValue == Encoder.Output, Encoder.Output == Decoder.Input {
    public func decode(prefsValue: StorageValue) -> Value? {
        let decoder = prefsDecoder()
        guard let value = try? decoder.decode(Value.self, from: prefsValue) else { return nil }
        return value
    }
    
    public func encode(prefsValue: Value) -> StorageValue? {
        let encoder = prefsEncoder()
        guard let encoded = try? encoder.encode(prefsValue) else { return nil }
        return encoded
    }
}
