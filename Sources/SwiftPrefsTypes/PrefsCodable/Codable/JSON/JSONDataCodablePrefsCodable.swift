//
//  JSONDataCodablePrefsCodable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw JSON `Data` storage with default options.
///
/// > Note:
/// > If custom `JSONEncoder`/`JSONDecoder` options are required, override the default implementation(s) of
/// > `prefEncoder()` and/or `prefDecoder()` methods to return an encoder/decoder with necessary options configured.
public protocol JSONDataCodablePrefsCodable: CodablePrefsCodable
where Encoder == JSONEncoder, Decoder == JSONDecoder, StorageValue == Data { }

extension JSONDataCodablePrefsCodable {
    public func prefsEncoder() -> JSONEncoder {
        JSONEncoder()
    }

    public func prefsDecoder() -> JSONDecoder {
        JSONDecoder()
    }
}
