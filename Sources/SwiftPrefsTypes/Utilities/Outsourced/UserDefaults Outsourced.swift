//
//  UserDefaults Outsourced.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Foundation/CharacterSet.swift
///
/// Borrowed from OTCore 1.6.0 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------
///

import Foundation

extension UserDefaults {
    // custom optional methods for core data types that don't intrinsically support optionals yet
    
    /// Convenience method to wrap the built-in `.integer(forKey:)` method in an optional returning nil if the key doesn't exist.
    @_disfavoredOverload
    func integerOptional(forKey key: String) -> Int? {
        guard object(forKey: key) != nil else { return nil }
        return integer(forKey: key)
    }
    
    /// Convenience method to wrap the built-in `.double(forKey:)` method in an optional returning nil if the key doesn't exist.
    @_disfavoredOverload
    func doubleOptional(forKey key: String) -> Double? {
        guard object(forKey: key) != nil else { return nil }
        return double(forKey: key)
    }
    
    /// Convenience method to wrap the built-in `.float(forKey:)` method in an optional returning nil if the key doesn't exist.
    @_disfavoredOverload
    func floatOptional(forKey key: String) -> Float? {
        guard object(forKey: key) != nil else { return nil }
        return float(forKey: key)
    }
    
    /// Convenience method to wrap the built-in `.bool(forKey:)` method in an optional returning nil if the key doesn't exist.
    @_disfavoredOverload
    func boolOptional(forKey key: String) -> Bool? {
        guard object(forKey: key) != nil else { return nil }
        return bool(forKey: key)
    }
    
    /// Returns `true` if the key exists.
    ///
    /// This method is only useful when you don't care about extracting a value from the key and merely want to check for the key's
    /// existence.
    @_disfavoredOverload
    func exists(key: String) -> Bool {
        object(forKey: key) != nil
    }
}
