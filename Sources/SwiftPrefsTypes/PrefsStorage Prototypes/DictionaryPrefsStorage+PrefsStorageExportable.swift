//
//  DictionaryPrefsStorage+PrefsStorageExportable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: PrefsStorageExportable {
    public func dictionaryRepresentation() throws -> [String: Any] {
        storage
    }
}
