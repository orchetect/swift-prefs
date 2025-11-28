//
//  PrefsStorageError.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum PrefsStorageError: LocalizedError {
    case contentExportingNotSupported
    case contentLoadingNotSupported
    case jsonExportError
    case jsonFormatNotSupported
    case jsonLoadingNotSupported
    case jsonWritingNotSupported
    case plistExportError
    case plistLoadingNotSupported
    case plistWritingNotSupported
    
    public var errorDescription: String? {
        switch self {
        case .contentExportingNotSupported:
            "Exporting content is not supported for this prefs storage implementation."
        case .contentLoadingNotSupported:
            "Loading content is not supported for this prefs storage implementation."
        case .jsonExportError:
            "JSON export failed."
        case .jsonFormatNotSupported:
            "JSON format is not supported or not recognized."
        case .jsonLoadingNotSupported:
            "Conversion from JSON is not supported for this prefs storage implementation."
        case .jsonWritingNotSupported:
            "Conversion to JSON format is not supported for this prefs storage implementation."
        case .plistExportError:
            "PList export failed."
        case .plistLoadingNotSupported:
            "Conversion from plist format is not supported for this prefs storage implementation."
        case .plistWritingNotSupported:
            "Conversion to plist format is not supported for this prefs storage implementation."
        }
    }
}
