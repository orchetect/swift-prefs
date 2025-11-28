//
//  JSONStringCodablePrefsCodable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw JSON `String` (UTF-8) storage with default
/// options.
///
/// > Note:
/// > If custom `JSONEncoder`/`JSONDecoder` options are required, override the default implementation(s) of
/// > `prefEncoder()` and/or `prefDecoder()` methods to return an encoder/decoder with necessary options configured.
public protocol JSONStringCodablePrefsCodable: CodablePrefsCodable
where Encoder == JSONEncoder, Decoder == JSONDecoder, StorageValue == String { }

extension JSONStringCodablePrefsCodable {
    public func prefsEncoder() -> JSONEncoder {
        JSONEncoder()
    }
    
    public func prefsDecoder() -> JSONDecoder {
        JSONDecoder()
    }
}

extension JSONStringCodablePrefsCodable {
    public func decode(prefsValue: StorageValue) -> Value? {
        let decoder = prefsDecoder()
        guard let data = prefsValue.data(using: .utf8),
              let value = try? decoder.decode(Value.self, from: data)
        else { return nil }
        return value
    }
    
    public func encode(prefsValue: Value) -> StorageValue? {
        let encoder = prefsEncoder()
        guard let data = try? encoder.encode(prefsValue),
              let string = String(data: data, encoding: .utf8)
        else { return nil }
        return string
    }
}
