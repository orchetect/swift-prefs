//
//  PrefsStorageMappingExportStrategy.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PrefsStorageMappingExportStrategy: PrefsStorageExportStrategy {
    func exportValue(forKeyPath keyPath: [String], value: Int) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: String) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Bool) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Double) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Float) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: NSNumber) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Data) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Date) throws -> Any
}

// MARK: - Default Implementation

extension PrefsStorageExportStrategy where Self: PrefsStorageMappingExportStrategy {
    public func prepareForExport(storage: [String: Any]) throws -> [String: Any] {
        // start recursive call at root
        try prepareForExport(keyPath: [], dict: storage)
    }
    
    func prepareForExport(keyPath: [String], dict: [String: Any]) throws -> [String: Any] {
        var copy = dict
        
        for (key, value) in copy {
            var keyPath = keyPath
            keyPath.append(key)
            copy[key] = try prepareForExport(keyPath: keyPath, element: value)
        }
        
        return copy
    }
    
    func prepareForExport(keyPath: [String], array: [Any]) throws -> Any {
        try array.map { try prepareForExport(keyPath: keyPath, element: $0) }
    }
    
    func prepareForExport(keyPath: [String], element: Any) throws -> Any {
        switch element {
        case let v as String:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as NSNumber where ["__NSCFNumber", "__NSCFBoolean"].contains("\(type(of: element))"):
            try prepareForExport(keyPath: keyPath, number: v)
        case let v as Int:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Bool:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Double:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Float:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Bool:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Data:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Date:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as [Any]:
            try prepareForExport(keyPath: keyPath, array: v)
        case let v as [String: Any]:
            try prepareForExport(keyPath: keyPath, dict: v)
        default:
            element
        }
    }
    
    func prepareForExport(
        keyPath: [String],
        number: NSNumber,
        typeEraseFloatingPoint: Bool = false
    ) throws -> Any {
        switch number {
        case let v as Bool where number.potentialNumberType == .int8_bool
            && "\(type(of: number))" == "__NSCFBoolean":
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Int where number.potentialNumberType == .int_uInt_uInt32_uInt64_uInt16:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Double where number.potentialNumberType == .double:
            typeEraseFloatingPoint
                ? try exportValue(forKeyPath: keyPath, value: number)
                : try exportValue(forKeyPath: keyPath, value: v)
        case let v as Float where number.potentialNumberType == .float:
            typeEraseFloatingPoint
                ? try exportValue(forKeyPath: keyPath, value: number)
                : try exportValue(forKeyPath: keyPath, value: v)
        default:
            number
        }
    }
}
