//
//  PrefsStorageModeWrapper.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Pref schema property access storage mode.
@propertyWrapper
public struct PrefsStorageModeWrapper {
    public var wrappedValue: PrefsStorageMode
    
    public init(wrappedValue: PrefsStorageMode) {
        self.wrappedValue = wrappedValue
    }
    
    public init(_ mode: PrefsStorageMode) {
        wrappedValue = mode
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension PrefsSchema {
    /// Pref schema property access storage mode.
    public typealias StorageMode = PrefsStorageModeWrapper
}
