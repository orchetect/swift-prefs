//
//  PList Utilities.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Import

extension [String: Any] {
    package init(plist url: URL) throws {
        let fileData = try Data(contentsOf: url)
        try self.init(plist: fileData)
    }
    
    package init(plist data: Data) throws {
        var fmt: PropertyListSerialization.PropertyListFormat = .xml // will be overwritten
        let dict = try PropertyListSerialization.propertyList(from: data, format: &fmt)
        guard let nsDict = dict as? NSDictionary else {
            throw CocoaError(.coderReadCorrupt)
        }
        try self.init(plist: nsDict)
    }
    
    package init(plist string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw CocoaError(.coderReadCorrupt)
        }
        try self.init(plist: data)
    }
    
    package init(plist dictionary: NSDictionary) throws {
        // let mappedDict = try convertToPrefDict(plist: dictionary)
        guard let mappedDict = dictionary as? [String: Any] else {
            throw CocoaError(.coderReadCorrupt)
        }
        self = mappedDict
    }
}

// MARK: - Export

extension [String: Any] {
    package func plistData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try PropertyListSerialization
            .data(fromPropertyList: self, format: format, options: .init())
    }
    
    package func plistString(encoding: String.Encoding = .utf8) throws -> String {
        let data = try plistData(format: .xml)
        guard let string = String(data: data, encoding: encoding) else {
            throw PrefsStorageError.plistExportError
        }
        return string
    }
}
