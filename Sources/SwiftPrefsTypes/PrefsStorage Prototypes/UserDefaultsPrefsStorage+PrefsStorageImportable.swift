//
//  UserDefaultsPrefsStorage+PrefsStorageImportable.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaultsPrefsStorage: PrefsStorageImportable {
    @discardableResult
    public func load(
        from contents: [String: any PrefsStorageValue],
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String> {
        switch behavior {
        case .reinitializing:
            suite.removeAllKeys()
            suite.merge(contents)
            return Set(contents.keys)
        case .updating:
            suite.merge(contents)
            return Set(contents.keys)
        case let .updatingWithPredicate(predicate):
            return try load(contents: contents, updatingWithPredicate: predicate)
        }
    }
    
    @discardableResult
    public func load(
        unsafe contents: [String: Any],
        by behavior: PrefsStorageUpdateStrategy
    ) throws -> Set<String> {
        switch behavior {
        case .reinitializing:
            suite.removeAllKeys()
            suite.merge(contents)
            return Set(contents.keys)
        case .updating:
            suite.merge(contents)
            return Set(contents.keys)
        case let .updatingWithPredicate(predicate):
            return try load(contents: contents, updatingWithPredicate: predicate)
        }
    }
}

// MARK: - Utilities

extension UserDefaultsPrefsStorage {
    func load(
        contents: [String: Any],
        updatingWithPredicate predicate: PrefsStorageUpdateStrategy.UpdatePredicate
    ) throws -> Set<String> {
        var updatedKeys: Set<String> = []
        
        for (key, newValue) in contents {
            if let existingValue = suite.object(forKey: key) {
                let result = try predicate(key, existingValue, newValue)
                switch result {
                case .preserveOldValue:
                    break
                case .takeNewValue:
                    suite.set(newValue, forKey: key)
                    updatedKeys.insert(key)
                }
            } else {
                suite.set(newValue, forKey: key)
                updatedKeys.insert(key)
            }
        }
        return updatedKeys
    }
}
