//
//  CompressedDataPrefsCoding.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Coding strategy for `Data` using data compression. Compresses when storing and decompresses when reading.
///
/// > Note:
/// >
/// > Due to inherent computational overhead with compression and decompression, this strategy is not recommended
/// > for use with data that has frequent access or requires low-latency access times.
public struct CompressedDataPrefsCoding: PrefsCodable {
    let algorithm: NSData.CompressionAlgorithm
    
    public init(algorithm: NSData.CompressionAlgorithm) {
        self.algorithm = algorithm
    }
    
    public func encode(prefsValue: Data) -> Data? {
        try? (prefsValue as NSData)
            .compressed(using: algorithm) as Data
    }

    public func decode(prefsValue: Data) -> Data? {
        try? (prefsValue as NSData)
            .decompressed(using: algorithm) as Data
    }
}

// MARK: - Static Constructor

extension PrefsCodable where Self == CompressedDataPrefsCoding {
    /// Coding strategy for `Data` using data compression. Compresses when storing and decompresses when reading.
    ///
    /// > Note:
    /// >
    /// > Due to inherent computational overhead with compression and decompression, this strategy is not recommended
    /// > for use with data that has frequent access or requires low-latency access times.
    public static func compressedData(
        algorithm: NSData.CompressionAlgorithm
    ) -> CompressedDataPrefsCoding {
        CompressedDataPrefsCoding(algorithm: algorithm)
    }
}

// MARK: - Chaining Constructor

extension PrefsCodable where StorageValue == CompressedDataPrefsCoding.Value {
    /// Coding strategy for `Data` using data compression. Compresses when storing and decompresses when reading.
    ///
    /// > Note:
    /// >
    /// > Due to inherent computational overhead with compression and decompression, this strategy is not recommended
    /// > for use with data that has frequent access or requires low-latency access times.
    public func compressedData(
        algorithm: NSData.CompressionAlgorithm
    ) -> PrefsCodingTuple<Self, CompressedDataPrefsCoding> {
        PrefsCodingTuple(
            self,
            CompressedDataPrefsCoding(algorithm: algorithm)
        )
    }
}
