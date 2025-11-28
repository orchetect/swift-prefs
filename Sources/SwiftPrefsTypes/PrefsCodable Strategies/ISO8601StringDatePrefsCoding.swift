//
//  ISO8601StringDatePrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Coding strategy for `Date` using standard ISO-8601 format `String` as the encoded storage value.
///
/// For example:
///
/// ```
/// 2024-12-31T21:30:35Z
/// ```
///
/// > Important:
/// >
/// > This format includes date and time with a resolution of 1 second. Any sub-second time information is truncated
/// > and discarded.
///
/// > Tip:
/// >
/// > `Date` has native `Codable` conformance, which means it may also be used directly with
/// > `@JSONDataCodablePref` or `@JSONStringCodablePref`.
public struct ISO8601DateStringPrefsCoding: PrefsCodable {
    public init() { }
    
    public func encode(prefsValue: Date) -> String? {
        ISO8601DateFormatter().string(from: prefsValue)
    }
    
    public func decode(prefsValue: String) -> Date? {
        ISO8601DateFormatter().date(from: prefsValue)
    }
}

// MARK: - Static Constructor

extension PrefsCodable where Self == ISO8601DateStringPrefsCoding {
    /// Coding strategy for `Date` using standard ISO-8601 format `String` as the encoded storage value.
    ///
    /// For example:
    ///
    /// ```
    /// 2024-12-31T21:30:35Z
    /// ```
    ///
    /// > Important:
    /// >
    /// > This format includes date and time with a resolution of 1 second. Any sub-second time information is truncated
    /// > and discarded.
    ///
    /// > Tip:
    /// >
    /// > `Date` has native `Codable` conformance, which means it may also be used directly with
    /// > `@JSONDataCodablePref` or `@JSONStringCodablePref`.
    public static var iso8601DateString: ISO8601DateStringPrefsCoding {
        ISO8601DateStringPrefsCoding()
    }
}

// MARK: - Chaining Constructor

// note: `Date` does not conform to PrefsStorageValue so we can't offer a coding strategy chaining method.
