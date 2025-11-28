//
//  PrefsStorageWrapper.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Prefs schema storage.
@propertyWrapper
public struct PrefsStorageWrapper<S> where S: PrefsStorage {
    public var wrappedValue: S
    
    public init(wrappedValue: S) {
        self.wrappedValue = wrappedValue
    }
    
    public init(_ storage: S) {
        wrappedValue = storage
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension PrefsSchema {
    /// Prefs schema storage.
    public typealias Storage = PrefsStorageWrapper
}
