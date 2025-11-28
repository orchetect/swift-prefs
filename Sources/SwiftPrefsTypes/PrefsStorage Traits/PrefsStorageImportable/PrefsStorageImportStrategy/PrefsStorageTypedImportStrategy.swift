//
//  PrefsStorageTypedImportStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Offers default ``PrefsStorageMappingImportStrategy`` implementation functionality.
public struct PrefsStorageTypedImportStrategy {
    public var typeEraseAmbiguousFloatingPoint: Bool
    
    public init(typeEraseAmbiguousFloatingPoint: Bool = false) {
        self.typeEraseAmbiguousFloatingPoint = typeEraseAmbiguousFloatingPoint
    }
}

extension PrefsStorageTypedImportStrategy: PrefsStorageMappingImportStrategy { }

// MARK: - Static Constructor

extension PrefsStorageImportStrategy where Self == PrefsStorageTypedImportStrategy {
    /// Offers default ``PrefsStorageMappingImportStrategy`` implementation functionality.
    public static func typed(typeEraseAmbiguousFloatingPoint: Bool = false) -> PrefsStorageTypedImportStrategy {
        PrefsStorageTypedImportStrategy(
            typeEraseAmbiguousFloatingPoint: typeEraseAmbiguousFloatingPoint
        )
    }
}
