//
//  Concurrency.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

@propertyWrapper
public struct SynchronizedLock<Value>: @unchecked Sendable {
    private var _value: Value
    private var lock = NSLock()
    
    public init(wrappedValue: Value) {
        _value = wrappedValue
    }
    
    public var wrappedValue: Value {
        get { lock.synchronized { _value } }
        set { lock.synchronized { _value = newValue } }
    }
    
    private mutating func synchronized<T>(block: (inout Value) throws -> T) rethrows -> T {
        try lock.synchronized {
            try block(&_value)
        }
    }
}

extension NSLocking {
    fileprivate func synchronized<T>(block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
