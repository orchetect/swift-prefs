//
//  AnyPrefsStorage+PrefsStorageImportable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorage: PrefsStorageImportable {
    @discardableResult
    public func load(
        from contents: [String: any PrefsStorageValue],
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String> {
        guard let wrapped = wrapped as? PrefsStorageImportable else {
            throw PrefsStorageError.contentLoadingNotSupported
        }
        return try wrapped.load(from: contents, by: behavior)
    }
    
    @discardableResult
    public func load(
        unsafe contents: [String: Any],
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String> {
        guard let wrapped = wrapped as? PrefsStorageImportable else {
            throw PrefsStorageError.contentLoadingNotSupported
        }
        return try wrapped.load(unsafe: contents, by: behavior)
    }
}
