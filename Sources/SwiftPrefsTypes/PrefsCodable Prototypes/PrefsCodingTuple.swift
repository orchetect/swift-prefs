//
//  PrefsCodingTuple.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// A container for two ``PrefsCodable`` coding strategies in series.
public struct PrefsCodingTuple<First, Second>: PrefsCodable
    where First: PrefsCodable, Second: PrefsCodable, First.StorageValue == Second.Value
{
    public typealias Value = First.Value
    public typealias StorageValue = Second.StorageValue
    
    public let first: First
    public let second: Second
    
    public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }
    
    public func decode(prefsValue: Second.StorageValue) -> First.Value? {
        guard let secondDecoded = second.decode(prefsValue: prefsValue) else { return nil }
        let firstDecoded = first.decode(prefsValue: secondDecoded)
        return firstDecoded
    }
    
    public func encode(prefsValue: First.Value) -> Second.StorageValue? {
        guard let firstEncoded = first.encode(prefsValue: prefsValue) else { return nil }
        let secondEncoded = second.encode(prefsValue: firstEncoded)
        return secondEncoded
    }
}
