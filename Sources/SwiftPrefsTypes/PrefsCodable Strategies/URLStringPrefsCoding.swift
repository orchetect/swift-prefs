//
//  URLStringPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Coding strategy for `URL` using absolute `String` as the encoded storage value type.
///
/// > Tip:
/// >
/// > `URL` has native `Codable` conformance, which means it may also be used directly with
/// > `@JSONDataCodablePref` or `@JSONStringCodablePref`.
public struct URLStringPrefsCoding: PrefsCodable {
    public init() { }
    
    public func encode(prefsValue: URL) -> String? {
        prefsValue.absoluteString
    }

    public func decode(prefsValue: String) -> URL? {
        URL(string: prefsValue)
    }
}

// MARK: - Static Constructor

extension PrefsCodable where Self == URLStringPrefsCoding {
    /// Coding strategy for `URL` using absolute `String` as the encoded storage value type.
    ///
    /// > Tip:
    /// >
    /// > `URL` has native `Codable` conformance, which means it may also be used directly with
    /// > `@JSONDataCodablePref` or `@JSONStringCodablePref`.
    public static var urlString: URLStringPrefsCoding { .init() }
}

// MARK: - Chaining Constructor

// note: `URL` does not conform to PrefsStorageValue so we can't offer a coding strategy chaining method.
