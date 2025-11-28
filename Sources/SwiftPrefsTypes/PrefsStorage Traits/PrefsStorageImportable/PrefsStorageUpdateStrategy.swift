//
//  PrefsStorageUpdateStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Contents loading behavior for ``PrefsStorage`` load methods.
public enum PrefsStorageUpdateStrategy {
    /// Replaces existing storage contents with new contents, removing all existing keys first.
    case reinitializing
    
    /// Merges new content with existing storage contents, overwriting a key's value in the event of a key name collision.
    case updating
    
    /// Merges new content with existing storage contents, using a user-defined predicate in the event of key name collisions.
    case updatingWithPredicate(_ predicate: UpdatePredicate)
}

extension PrefsStorageUpdateStrategy: Sendable { }

extension PrefsStorageUpdateStrategy {
    public typealias UpdatePredicate = @Sendable (_ key: String, _ oldValue: Any, _ newValue: Any) throws -> ValueUpdateResult
}

extension PrefsStorageUpdateStrategy {
    public enum ValueUpdateResult {
        case preserveOldValue
        case takeNewValue
    }
}

extension PrefsStorageUpdateStrategy.ValueUpdateResult: Sendable { }
