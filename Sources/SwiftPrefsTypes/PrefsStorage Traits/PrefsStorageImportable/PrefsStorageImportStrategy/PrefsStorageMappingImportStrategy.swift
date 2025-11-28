//
//  PrefsStorageMappingImportStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Prefs import strategy that provides a framework for mapping/converting value types.
/// Default implementation is provided and `importValue` methods may be overridden to provide custom behavior for any
/// atomic storage value type.
public protocol PrefsStorageMappingImportStrategy: PrefsStorageImportStrategy {
    /// When `true`, ambiguous floating-point values will be type-erased as `NSNumber`.
    ///
    /// > Note:
    /// >
    /// > This property has no effect if the default implementation of
    /// > `func importValue(forKeyPath: [String], value: NSNumber)` is overridden.
    var typeEraseAmbiguousFloatingPoint: Bool { get set }
    
    func importValue(forKeyPath keyPath: [String], value: Int) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: String) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Bool) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Double) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Float) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: NSNumber) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Data) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Date) throws -> any PrefsStorageValue
}

// MARK: - Default Implementation

extension PrefsStorageMappingImportStrategy {
    public func importValue(forKeyPath keyPath: [String], value: Int) throws -> any PrefsStorageValue {
        value
    }
    
    public func importValue(forKeyPath keyPath: [String], value: String) throws -> any PrefsStorageValue {
        value
    }
    
    public func importValue(forKeyPath keyPath: [String], value: Bool) throws -> any PrefsStorageValue {
        value
    }
    
    public func importValue(forKeyPath keyPath: [String], value: Double) throws -> any PrefsStorageValue {
        value
    }
    
    public func importValue(forKeyPath keyPath: [String], value: Float) throws -> any PrefsStorageValue {
        value
    }
    
    public func importValue(forKeyPath keyPath: [String], value: NSNumber) throws -> any PrefsStorageValue {
        convert(value, typeEraseFloatingPoint: typeEraseAmbiguousFloatingPoint)
    }
    
    public func importValue(forKeyPath keyPath: [String], value: Data) throws -> any PrefsStorageValue {
        value
    }
    
    public func importValue(forKeyPath keyPath: [String], value: Date) throws -> any PrefsStorageValue {
        value
    }
}

extension PrefsStorageImportStrategy where Self: PrefsStorageMappingImportStrategy {
    public func prepareForImport(storage: [String: Any]) throws -> [String: Any] {
        // start recursive call at root
        try prepareForImport(keyPath: [], dict: storage)
    }
    
    func prepareForImport(keyPath: [String], dict: [String: Any]) throws -> [String: Any] {
        var copy = dict
        
        for (key, value) in copy {
            var keyPath = keyPath
            keyPath.append(key)
            copy[key] = try prepareForImport(keyPath: keyPath, element: value)
        }
        
        return copy
    }
    
    func prepareForImport(keyPath: [String], array: [Any]) throws -> Any {
        try array.map { try prepareForImport(keyPath: keyPath, element: $0) }
    }
    
    func prepareForImport(keyPath: [String], element: Any) throws -> Any {
        switch element {
        case let v as String:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as NSNumber where ["__NSCFNumber", "__NSCFBoolean"].contains("\(type(of: element))"):
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Int:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Bool:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Double:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Float:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Data:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Date:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as [Any]:
            try prepareForImport(keyPath: keyPath, array: v)
        case let v as [String: Any]:
            try prepareForImport(keyPath: keyPath, dict: v)
        default:
            element
        }
    }
}

// MARK: - Internal Utilities

extension PrefsStorageImportStrategy {
    public func convert(_ number: NSNumber, typeEraseFloatingPoint: Bool) -> any PrefsStorageValue {
        switch number {
        case let v as Bool where number.potentialNumberType == .int8_bool
            && "\(type(of: number))" == "__NSCFBoolean":
            v
        case let v as Int where number.potentialNumberType == .int_uInt_uInt32_uInt64_uInt16:
            v
        case let v as Double where number.potentialNumberType == .double:
            typeEraseFloatingPoint ? number : v
        case let v as Float where number.potentialNumberType == .float:
            typeEraseFloatingPoint ? number : v
        default:
            number
        }
    }
}
