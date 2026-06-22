//
//  AnyPrefsStorage+PrefsStorageExportable.swift
//  SwiftPrefs • https://github.com/orchetect/swift-prefs
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorage: PrefsStorageExportable {
    public func dictionaryRepresentation() throws -> [String: Any] {
        guard let wrapped = wrapped as? PrefsStorageExportable else {
            throw PrefsStorageError.contentExportingNotSupported
        }
        return try wrapped.dictionaryRepresentation()
    }
}
