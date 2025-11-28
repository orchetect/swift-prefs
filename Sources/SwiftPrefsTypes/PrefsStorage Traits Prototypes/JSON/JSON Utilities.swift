//
//  JSON Utilities.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Import

extension [String: Any] {
    package init(json url: URL, options: JSONSerialization.ReadingOptions = []) throws {
        let fileData = try Data(contentsOf: url)
        try self.init(json: fileData, options: options)
    }
    
    package init(json data: Data, options: JSONSerialization.ReadingOptions = []) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: options)
        guard let dictionary = object as? [String: Any] else {
            throw PrefsStorageError.jsonFormatNotSupported
        }
        self = dictionary
    }
    
    package init(json string: String, options: JSONSerialization.ReadingOptions = []) throws {
        guard let data = string.data(using: .utf8) else {
            throw PrefsStorageError.jsonFormatNotSupported
        }
        try self.init(json: data, options: options)
    }
}

// MARK: - Export

extension [String: Any] {
    package func jsonData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        try JSONSerialization
            .data(withJSONObject: self, options: options)
    }
    
    package func jsonString(
        options: JSONSerialization.WritingOptions = [],
        encoding: String.Encoding = .utf8
    ) throws -> String {
        let data = try jsonData(options: options)
        guard let string = String(data: data, encoding: encoding) else {
            throw PrefsStorageError.jsonExportError
        }
        return string
    }
}
