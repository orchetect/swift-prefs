//
//  AtomicPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2026 Steffan Andrews • Licensed under MIT License
//

/// A basic prefs value coding strategy that stores a standard atomic value type directly without any additional
/// processing.
public struct AtomicPrefsCoding<Value: PrefsStorageValue>: AtomicPrefsCodable {
    public typealias Value = Value

    public init() { }
}
