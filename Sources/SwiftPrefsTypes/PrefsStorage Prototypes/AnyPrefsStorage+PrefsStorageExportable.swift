//
//  AnyPrefsStorage+PrefsStorageExportable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
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
