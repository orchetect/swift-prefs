//
//  UserDefaultsPrefsSchemaTests.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftPrefsCore
import Testing

@Suite(.serialized)
struct UserDefaultsPrefsSchemaTests {
    static let domain = "com.orchetect.swift-prefs.\(type(of: Self.self))"
    
    static func testSuite() -> UserDefaults {
        UserDefaults(suiteName: domain)!
    }
    
    // MARK: - Init
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    init() {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
    }
    
    // MARK: - Mock Types
    
    enum RawEnum: String, RawRepresentable {
        case one
        case two
    }
    
    enum CodableEnum: String, Codable {
        case one
        case two
    }
    
    // MARK: - Protocol Adoptions
    
    struct MockAtomicPrefsCoding: AtomicPrefsCodable {
        typealias Value = Bool
    }
    
    struct MockRawRepresentablePrefsCoding: RawRepresentablePrefsCodable {
        typealias Value = RawEnum
    }
    
    struct MockCodablePrefsCoding: CodablePrefsCodable {
        typealias Value = CodableEnum
        
        func prefsEncoder() -> JSONEncoder { JSONEncoder() }
        func prefsDecoder() -> JSONDecoder { JSONDecoder() }
    }
    
    struct MockJSONCodablePrefsCoding: JSONDataCodablePrefsCodable {
        typealias Value = CodableEnum
    }
    
    enum Key {
        static let foo = "foo"
        static let fooDefaulted = "fooDefaulted"
        static let bar = "bar"
        static let rawRep = "rawRep"
        static let rawRepDefaulted = "rawRepDefaulted"
        static let rawFoo = "rawFoo"
        static let rawBar = "rawBar"
        static let codable = "codable"
        static let codableDefaulted = "codableDefaulted"
        static let codable2 = "codable2"
        static let codableDefaulted2 = "codableDefaulted2"
        static let jsonCodable = "jsonCodable"
        static let jsonCodableDefaulted = "jsonCodableDefaulted"
        static let jsonCodableFoo = "jsonCodableFoo"
        static let jsonCodableBar = "jsonCodableBar"
        static let url = "url"
        static let urlDefaulted = "urlDefaulted"
        
        static let int = "int"
        static let string = "string"
        static let bool = "bool"
        static let double = "double"
        static let float = "float"
        static let data = "data"
        static let date = "date"
        static let array = "array"
        static let anyArray = "anyArray"
        static let stringArray = "stringArray"
        static let dict = "dict"
        static let anyDict = "anyDict"
        static let stringDict = "stringDict"
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        let storage: AnyPrefsStorage
        let storageMode: PrefsStorageMode
        
        init(storage: any PrefsStorage, storageMode: PrefsStorageMode) {
            self.storage = AnyPrefsStorage(storage)
            self.storageMode = storageMode
        }
        
        // MARK: Key names supplied in key argument
        
        // Defined Key Implementations
        
        @Pref(key: Key.foo, coding: MockAtomicPrefsCoding()) var atomic: Bool?
        @Pref(key: Key.fooDefaulted, coding: MockAtomicPrefsCoding()) var atomicDefaulted: Bool = true

        @Pref(key: Key.rawRep, coding: MockRawRepresentablePrefsCoding()) var rawRep: RawEnum?
        @Pref(key: Key.rawRepDefaulted, coding: MockRawRepresentablePrefsCoding()) var rawRepDefaulted: RawEnum = .one
        
        @RawRepresentablePref(key: Key.rawFoo) var rawRep2: RawEnum?
        @RawRepresentablePref(key: Key.rawBar) var rawRepDefaulted2: RawEnum = .one

        @Pref(key: Key.codable, coding: MockCodablePrefsCoding()) var codable: CodableEnum?
        @Pref(key: Key.codableDefaulted, coding: MockCodablePrefsCoding()) var codableDefaulted: CodableEnum = .one
        
        @Pref(
            key: Key.codable2,
            coding: CodablePrefsCoding(
                value: CodableEnum.self,
                storageValue: JSONEncoder.Output.self,
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            )
        ) var codable2: CodableEnum?
        @Pref(
            key: Key.codableDefaulted2,
            coding: CodablePrefsCoding(
                value: CodableEnum.self,
                storageValue: JSONEncoder.Output.self,
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            )
        ) var codableDefaulted2: CodableEnum = .one
        
        @Pref(key: Key.jsonCodable, coding: MockJSONCodablePrefsCoding()) var jsonCodable: CodableEnum?
        @Pref(key: Key.jsonCodableDefaulted, coding: MockJSONCodablePrefsCoding()) var jsonCodableDefaulted: CodableEnum = .one
        
        @JSONStringCodablePref(key: Key.codable2) var jsonCodable2: CodableEnum?
        @JSONDataCodablePref(key: Key.codable2) var jsonCodableDefaulted2: CodableEnum = .one
        
        @Pref(
            key: Key.url,
            encode: { $0.absoluteString },
            decode: { URL(string: $0) }
        ) var url: URL?
        @Pref(
            key: Key.urlDefaulted,
            encode: { $0.absoluteString },
            decode: { URL(string: $0) }
        ) var urlDefaulted: URL = URL(string: "https://example.com")!
        
        // Synthesized Key Implementations
        
        // Atomic
        @Pref(key: Key.int) var int: Int?
        @Pref(key: Key.string) var string: String?
        @Pref(key: Key.bool) var bool: Bool?
        @Pref(key: Key.double) var double: Double?
        @Pref(key: Key.float) var float: Float?
        @Pref(key: Key.data) var data: Data?
        @Pref(key: Key.date) var date: Date?
        // @Pref(key: Key.anyArray) var anyArray: [Any]? // doesn't conform to `PrefsStorageValue`
        @Pref(key: Key.stringArray) var stringArray: [String]?
        // @Pref(key: Key.anyDict) var anyDict: [String: Any]? // doesn't conform to `PrefsStorageValue`
        @Pref(key: Key.stringDict) var stringDict: [String: String]?
        
        // Atomic (Defaulted)
        @Pref(key: Key.int) var intDefaulted: Int = 1
        @Pref(key: Key.string) var stringDefaulted: String = "a string"
        @Pref(key: Key.bool) var boolDefaulted: Bool = true
        @Pref(key: Key.double) var doubleDefaulted: Double = 1.5
        @Pref(key: Key.float) var floatDefaulted: Float = 2.5
        @Pref(key: Key.data) var dataDefaulted: Data = Data([0x01, 0x02])
        @Pref(key: Key.date) var dateDefaulted: Date = ISO8601DateFormatter().date(from: "2025-01-07T05:32:03Z")!
        // @Pref(key: Key.anyArray) var anyArrayDefaulted: [Any] = [123, "a string"] // doesn't conform to `PrefsStorageValue`
        @Pref(key: Key.stringArray) var stringArrayDefaulted: [String] = ["a", "b"]
        // @Pref(key: Key.anyDict) var anyDictDefaulted: [String: Any] = ["foo": 123, "bar": "a string"] // doesn't conform to `PrefsStorageValue`
        @Pref(key: Key.stringDict) var stringDictDefaulted: [String: String] = ["a": "123", "b": "456"]
        
        // MARK: Key names derived from variable names
        
        // Defined Key Implementations
        
        @Pref(coding: MockAtomicPrefsCoding()) var x_atomic: Bool?
        @Pref(coding: MockAtomicPrefsCoding()) var x_atomicDefaulted: Bool = true
        
        @Pref(coding: MockRawRepresentablePrefsCoding()) var x_rawRep: RawEnum?
        @Pref(coding: MockRawRepresentablePrefsCoding()) var x_rawRepDefaulted: RawEnum = .one
        
        @RawRepresentablePref var x_rawRep2: RawEnum?
        @RawRepresentablePref var x_rawRepDefaulted2: RawEnum = .one
        
        @Pref(coding: MockCodablePrefsCoding()) var x_codable: CodableEnum?
        @Pref(coding: MockCodablePrefsCoding()) var x_codableDefaulted: CodableEnum = .one
        
        @Pref(
            coding: CodablePrefsCoding(
                value: CodableEnum.self,
                storageValue: JSONEncoder.Output.self,
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            )
        ) var x_codable2: CodableEnum?
        @Pref(
            coding: CodablePrefsCoding(
                value: CodableEnum.self,
                storageValue: JSONEncoder.Output.self,
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            )
        ) var x_codableDefaulted2: CodableEnum = .one
        
        @Pref(coding: MockJSONCodablePrefsCoding()) var x_jsonCodable: CodableEnum?
        @Pref(coding: MockJSONCodablePrefsCoding()) var x_jsonCodableDefaulted: CodableEnum = .one
        
        @JSONStringCodablePref var x_jsonCodable2: CodableEnum?
        @JSONDataCodablePref var x_jsonCodableDefaulted2: CodableEnum = .one
        
        @Pref(encode: { $0.absoluteString }, decode: { URL(string: $0) }) var x_url: URL?
        @Pref(encode: { $0.absoluteString }, decode: { URL(string: $0) }) var x_urlDefaulted: URL = URL(string: "https://example.com")!
        
        // Synthesized Key Implementations
        @Pref var x_int: Int?
        @Pref var x_string: String?
        @Pref var x_bool: Bool?
        @Pref var x_double: Double?
        @Pref var x_float: Float?
        @Pref var x_data: Data?
        // @Pref var x_anyArray: [Any]? // doesn't conform to `PrefsStorageValue`
        @Pref var x_stringArray: [String]?
        // @Pref var x_anyDict: [String: Any]? // doesn't conform to `PrefsStorageValue`
        @Pref var x_stringDict: [String: String]?
        
        // Atomic (Defaulted)
        @Pref var x_intDefaulted: Int = 1
        @Pref var x_stringDefaulted: String = "a string"
        @Pref var x_boolDefaulted: Bool = true
        @Pref var x_doubleDefaulted: Double = 1.5
        @Pref var x_floatDefaulted: Float = 2.5
        @Pref var x_dataDefaulted: Data = Data([0x01, 0x02])
        // @Pref var x_anyArrayDefaulted: [Any] = [123, "a string"] // doesn't conform to `PrefsStorageValue`
        @Pref var x_stringArrayDefaulted: [String] = ["a", "b"]
        // @Pref var x_anyDictDefaulted: [String: Any] = ["foo": 123, "bar": "a string"] // doesn't conform to `PrefsStorageValue`
        @Pref var x_stringDictDefaulted: [String: String] = ["a": "123", "b": "456"]
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    static var schemas: [TestSchema] {
        [
            TestSchema(storage: UserDefaultsPrefsStorage(suite: testSuite()), storageMode: .cachedReadStorageWrite),
            TestSchema(storage: UserDefaultsPrefsStorage(suite: testSuite()), storageMode: .storageOnly),
            TestSchema(storage: DictionaryPrefsStorage(), storageMode: .cachedReadStorageWrite),
            TestSchema(storage: DictionaryPrefsStorage(), storageMode: .storageOnly)
        ]
    }
    
    // MARK: - Defined Key Implementations
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func atomicPrefKey(schema: TestSchema) async throws {
        #expect(schema.atomic == nil)
        
        schema.atomic = false
        #expect(schema.atomic == false)
        
        schema.atomic = true
        #expect(schema.atomic == true)
        
        schema.atomic?.toggle()
        #expect(schema.atomic == false)
        
        schema.atomic = nil
        #expect(schema.atomic == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func atomicDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.atomicDefaulted == true)
        
        schema.atomicDefaulted = false
        #expect(schema.atomicDefaulted == false)
        
        schema.atomicDefaulted.toggle()
        #expect(schema.atomicDefaulted == true)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func rawRepresentablePrefKey(schema: TestSchema) async throws {
        #expect(schema.rawRep == nil)
        
        schema.rawRep = .one
        #expect(schema.rawRep == .one)
        
        schema.rawRep = .two
        #expect(schema.rawRep == .two)
        
        schema.rawRep = nil
        #expect(schema.rawRep == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func rawRepresentableDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.rawRepDefaulted == .one)
        
        schema.rawRepDefaulted = .one
        #expect(schema.rawRepDefaulted == .one)
        
        schema.rawRepDefaulted = .two
        #expect(schema.rawRepDefaulted == .two)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func rawRepresentable2PrefKey(schema: TestSchema) async throws {
        #expect(schema.rawRep2 == nil)
        
        schema.rawRep2 = .one
        #expect(schema.rawRep2 == .one)
        
        schema.rawRep2 = .two
        #expect(schema.rawRep2 == .two)
        
        schema.rawRep2 = nil
        #expect(schema.rawRep2 == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func rawRepresentableDefaulted2PrefKey(schema: TestSchema) async throws {
        #expect(schema.rawRepDefaulted2 == .one)
        
        schema.rawRepDefaulted2 = .one
        #expect(schema.rawRepDefaulted2 == .one)
        
        schema.rawRepDefaulted2 = .two
        #expect(schema.rawRepDefaulted2 == .two)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func codablePrefKey(schema: TestSchema) async throws {
        #expect(schema.codable == nil)
        
        schema.codable = .one
        #expect(schema.codable == .one)
        
        schema.codable = .two
        #expect(schema.codable == .two)
        
        schema.codable = nil
        #expect(schema.codable == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func codableDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.codableDefaulted == .one)
        
        schema.codableDefaulted = .one
        #expect(schema.codableDefaulted == .one)
        
        schema.codableDefaulted = .two
        #expect(schema.codableDefaulted == .two)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func codable2PrefKey(schema: TestSchema) async throws {
        #expect(schema.codable2 == nil)
        
        schema.codable2 = .one
        #expect(schema.codable2 == .one)
        
        schema.codable2 = .two
        #expect(schema.codable2 == .two)
        
        schema.codable2 = nil
        #expect(schema.codable2 == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func codableDefaulted2PrefKey(schema: TestSchema) async throws {
        #expect(schema.codableDefaulted2 == .one)
        
        schema.codableDefaulted2 = .one
        #expect(schema.codableDefaulted2 == .one)
        
        schema.codableDefaulted2 = .two
        #expect(schema.codableDefaulted2 == .two)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func jsonCodablePrefsCodable(schema: TestSchema) async throws {
        #expect(schema.jsonCodable == nil)
        
        schema.jsonCodable = .one
        #expect(schema.jsonCodable == .one)
        
        schema.jsonCodable = .two
        #expect(schema.jsonCodable == .two)
        
        schema.jsonCodable = nil
        #expect(schema.jsonCodable == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func jsonCodableDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.jsonCodableDefaulted == .one)
        
        schema.jsonCodableDefaulted = .one
        #expect(schema.jsonCodableDefaulted == .one)
        
        schema.jsonCodableDefaulted = .two
        #expect(schema.jsonCodableDefaulted == .two)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func jsonCodable2PrefKey(schema: TestSchema) async throws {
        #expect(schema.jsonCodable2 == nil)
        
        schema.jsonCodable2 = .one
        #expect(schema.jsonCodable2 == .one)
        
        schema.jsonCodable2 = .two
        #expect(schema.jsonCodable2 == .two)
        
        schema.jsonCodable2 = nil
        #expect(schema.jsonCodable2 == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func jsonCodableDefaulted2PrefKey(schema: TestSchema) async throws {
        #expect(schema.jsonCodableDefaulted2 == .one)
        
        schema.jsonCodableDefaulted2 = .one
        #expect(schema.jsonCodableDefaulted2 == .one)
        
        schema.jsonCodableDefaulted2 = .two
        #expect(schema.jsonCodableDefaulted2 == .two)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func urlPrefKey(schema: TestSchema) async throws {
        #expect(schema.url == nil)
        
        schema.url = URL(string: "https://apple.com")!
        #expect(schema.url == URL(string: "https://apple.com")!)
        
        schema.url = URL(string: "https://google.com")!
        #expect(schema.url == URL(string: "https://google.com")!)
        
        schema.jsonCodable2 = nil
        #expect(schema.jsonCodable2 == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func urlDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.urlDefaulted == URL(string: "https://example.com")!)
        
        schema.urlDefaulted = URL(string: "https://apple.com")!
        #expect(schema.urlDefaulted == URL(string: "https://apple.com")!)
        
        schema.urlDefaulted = URL(string: "https://google.com")!
        #expect(schema.urlDefaulted == URL(string: "https://google.com")!)
        
        // can't set nil
    }
    
    // MARK: - Synthesized Key Implementations: Non-Defaulted (Atomic)
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func intPrefKey(schema: TestSchema) async throws {
        #expect(schema.int == nil)
        
        schema.int = 1
        #expect(schema.int == 1)
        
        schema.int = 2
        #expect(schema.int == 2)
        
        schema.int? += 1
        #expect(schema.int == 3)
        
        schema.int = nil
        #expect(schema.int == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func stringPrefKey(schema: TestSchema) async throws {
        #expect(schema.string == nil)
        
        schema.string = "1"
        #expect(schema.string == "1")
        
        schema.string = "2"
        #expect(schema.string == "2")
        
        schema.string? += "0"
        #expect(schema.string == "20")
        
        schema.string = nil
        #expect(schema.string == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func boolPrefKey(schema: TestSchema) async throws {
        #expect(schema.bool == nil)
        
        schema.bool = true
        #expect(schema.bool == true)
        
        schema.bool = false
        #expect(schema.bool == false)
        
        schema.bool?.toggle()
        #expect(schema.bool == true)
        
        schema.bool = nil
        #expect(schema.bool == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func doublePrefKey(schema: TestSchema) async throws {
        #expect(schema.double == nil)
        
        schema.double = 1.5
        #expect(schema.double == 1.5)
        
        schema.double = 2.0
        #expect(schema.double == 2.0)
        
        schema.double? += 1.0
        #expect(schema.double == 3.0)
        
        schema.double = nil
        #expect(schema.double == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func floatPrefKey(schema: TestSchema) async throws {
        #expect(schema.float == nil)
        
        schema.float = 1.5
        #expect(schema.float == 1.5)
        
        schema.float = 2.0
        #expect(schema.float == 2.0)
        
        schema.float? += 1.0
        #expect(schema.float == 3.0)
        
        schema.float = nil
        #expect(schema.float == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func dataPrefKey(schema: TestSchema) async throws {
        #expect(schema.data == nil)
        
        schema.data = Data([0x01, 0x02])
        #expect(schema.data == Data([0x01, 0x02]))
        
        schema.data = Data([0x03, 0x04])
        #expect(schema.data == Data([0x03, 0x04]))
        
        schema.data?.append(contentsOf: [0x05])
        #expect(schema.data == Data([0x03, 0x04, 0x05]))
        
        schema.data = nil
        #expect(schema.data == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func datePrefKey(schema: TestSchema) async throws {
        #expect(schema.date == nil)
        
        schema.date = ISO8601DateFormatter().date(from: "2025-01-07T05:32:03Z")!
        #expect(schema.date == ISO8601DateFormatter().date(from: "2025-01-07T05:32:03Z")!)
        
        schema.date = ISO8601DateFormatter().date(from: "2025-01-07T05:32:04Z")!
        #expect(schema.date == ISO8601DateFormatter().date(from: "2025-01-07T05:32:04Z")!)
        
        schema.date?.addTimeInterval(1.0)
        #expect(schema.date == ISO8601DateFormatter().date(from: "2025-01-07T05:32:05Z")!)
        
        schema.date = nil
        #expect(schema.date == nil)
    }
    
    // @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    // @Test(arguments: schemas)
    // func anyArrayPrefKey(schema: TestSchema) async throws {
    //     #expect(schema.anyArray == nil)
    //
    //     schema.anyArray = ["abc"].asAnyPrefsStorageValues
    //     #expect(schema.anyArray?.count == 1)
    //     #expect(schema.anyArray?[0].unwrapped as? String == "abc")
    //
    //     schema.anyArray?.append(AnyPrefsStorageValue("xyz")!)
    //     #expect(schema.anyArray?.count == 2)
    //     #expect(schema.anyArray?[0].unwrapped as? String == "abc")
    //     #expect(schema.anyArray?[1].unwrapped as? String == "xyz")
    //
    //     schema.anyArray = [
    //         1 as Int,
    //         "xyz",
    //         true,
    //         150.0 as Double,
    //         200.5 as Float,
    //         Data([0x03, 0x04]),
    //         [123],
    //         [456, "test"].asAnyPrefsStorageValues,
    //         ["def": 234, "ghi": "str"].asAnyPrefsStorageValues
    //     ].asAnyPrefsStorageValues
    //     #expect(schema.anyArray?.count == 8)
    //     #expect(schema.anyArray?[0].unwrapped as? Int == 1)
    //     #expect(schema.anyArray?[1].unwrapped as? String == "xyz")
    //     #expect(schema.anyArray?[2].unwrapped as? Bool == true)
    //     #expect(schema.anyArray?[3].unwrapped as? Double == 150.0)
    //     #expect(schema.anyArray?[4].unwrapped as? Float == 200.5)
    //     #expect(schema.anyArray?[5].unwrapped as? Data == Data([0x03, 0x04]))
    //     #expect(schema.anyArray?[6].unwrapped as? [Int] == [123])
    //     let arr = schema.anyArray?[7].unwrapped as? [AnyPrefsStorageValue]
    //     #expect(arr?[0].unwrapped as? Int == 456)
    //     #expect(arr?[1].unwrapped as? String == "test")
    //     let dict = schema.anyArray?[8] as? [String: AnyPrefsStorageValue]
    //     #expect(dict?["def"]?.unwrapped as? Int == 234)
    //     #expect(dict?["ghi"]?.unwrapped as? String == "str")
    //
    //     schema.anyArray = nil
    //     #expect(schema.anyArray == nil)
    // }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func typedArrayPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringArray == nil)
        
        schema.stringArray = ["abc"]
        #expect(schema.stringArray?.count == 1)
        #expect(schema.stringArray?[0] == "abc")
        
        schema.stringArray?[0] = "foo"
        #expect(schema.stringArray?.count == 1)
        #expect(schema.stringArray?[0] == "foo")
        
        schema.stringArray = ["def", "xyz"]
        #expect(schema.stringArray?.count == 2)
        #expect(schema.stringArray?[0] == "def")
        #expect(schema.stringArray?[1] == "xyz")
        
        schema.stringArray = nil
        #expect(schema.stringArray == nil)
    }
    
    // @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    // @Test(arguments: schemas)
    // func anyDictionaryPrefKey(schema: TestSchema) async throws {
    //     #expect(schema.anyDict == nil)
    //
    //     schema.anyDict = ["abc": 123].asAnyPrefsStorageValues
    //     #expect(schema.anyDict?.count == 1)
    //     #expect(schema.anyDict?["abc"] as? Int == 123)
    //
    //     schema.anyDict = [
    //         "a": 1 as Int,
    //         "b": "xyz",
    //         "c": true,
    //         "d": 150.0 as Double,
    //         "e": 200.5 as Float,
    //         "f": Data([0x03, 0x04]),
    //         "g": [456, "test"].asAnyPrefsStorageValues,
    //         "h": ["def": 234, "ghi": 500.6].asAnyPrefsStorageValues
    //     ].asAnyPrefsStorageValues
    //     #expect(schema.anyDict?.count == 8)
    //     #expect(schema.anyDict?["a"] as? Int == 1)
    //     #expect(schema.anyDict?["b"] as? String == "xyz")
    //     #expect(schema.anyDict?["c"] as? Bool == true)
    //     #expect(schema.anyDict?["d"] as? Double == 150.0)
    //     #expect(schema.anyDict?["e"] as? Float == 200.5)
    //     #expect(schema.anyDict?["f"] as? Data == Data([0x03, 0x04]))
    //
    //     let arr = schema.anyDict?["g"] as? [any PrefsStorageValue]
    //     #expect(arr?[0] as? Int == 456)
    //     #expect(arr?[1] as? String == "test")
    //
    //     let dict = schema.anyDict?["h"] as? [String: any PrefsStorageValue]
    //     #expect(dict?["def"] as? Int == 234)
    //     #expect(dict?["ghi"] as? Double == 500.6)
    //
    //     schema.anyDict = nil
    //     #expect(schema.anyDict == nil)
    // }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func typedDictionaryPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringDict == nil)
        
        schema.stringDict = ["a": "abc"]
        #expect(schema.stringDict?.count == 1)
        #expect(schema.stringDict?["a"] == "abc")
        
        schema.stringDict?["a"] = "def"
        #expect(schema.stringDict?.count == 1)
        #expect(schema.stringDict?["a"] == "def")
        
        schema.stringDict = nil
        #expect(schema.stringDict == nil)
    }
    
    // MARK: - Synthesized Key Implementations: Defaulted (Atomic)
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func intDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.intDefaulted == 1)
        
        schema.intDefaulted = 2
        #expect(schema.intDefaulted == 2)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func stringDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringDefaulted == "a string")
        
        schema.stringDefaulted = "1"
        #expect(schema.stringDefaulted == "1")
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func boolDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.boolDefaulted == true)
        
        schema.boolDefaulted = false
        #expect(schema.boolDefaulted == false)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func doubleDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.doubleDefaulted == 1.5)
        
        schema.doubleDefaulted = 3.25
        #expect(schema.doubleDefaulted == 3.25)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func floatDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.floatDefaulted == 2.5)
        
        schema.floatDefaulted = 5.6
        #expect(schema.floatDefaulted == 5.6)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func dataDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.dataDefaulted == Data([0x01, 0x02]))
        
        schema.dataDefaulted = Data([0x03, 0x04])
        #expect(schema.dataDefaulted == Data([0x03, 0x04]))
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func dateDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.dateDefaulted == ISO8601DateFormatter().date(from: "2025-01-07T05:32:03Z")!)
        
        schema.dateDefaulted = ISO8601DateFormatter().date(from: "2025-01-07T05:32:04Z")!
        #expect(schema.dateDefaulted == ISO8601DateFormatter().date(from: "2025-01-07T05:32:04Z")!)
        
        schema.dateDefaulted.addTimeInterval(1.0)
        #expect(schema.dateDefaulted == ISO8601DateFormatter().date(from: "2025-01-07T05:32:05Z")!)
    }
    
    // @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    // @Test(arguments: schemas)
    // func anyArrayDefaultedPrefKey(schema: TestSchema) async throws {
    //     #expect(schema.anyArrayDefaulted.count == 2)
    //     #expect(schema.anyArrayDefaulted[0].unwrapped as? Int == 123)
    //     #expect(schema.anyArrayDefaulted[1].unwrapped as? String == "a string")
    //
    //     schema.anyArrayDefaulted = ["abc"].asAnyPrefsStorageValues
    //     #expect(schema.anyArrayDefaulted.count == 1)
    //     #expect(schema.anyArrayDefaulted[0].unwrapped as? String == "abc")
    // }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func stringArrayDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringArrayDefaulted.count == 2)
        #expect(schema.stringArrayDefaulted == ["a", "b"])
        
        schema.stringArrayDefaulted = ["abc"]
        #expect(schema.stringArrayDefaulted.count == 1)
        #expect(schema.stringArrayDefaulted == ["abc"])
    }
    
    // @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    // @Test(arguments: schemas)
    // func anyDictionaryDefaultedPrefKey(schema: TestSchema) async throws {
    //     #expect(schema.anyDictDefaulted.count == 2)
    //     #expect(schema.anyDictDefaulted["foo"]?.unwrapped as? Int == 123)
    //     #expect(schema.anyDictDefaulted["bar"]?.unwrapped as? String == "a string")
    //
    //     schema.anyDictDefaulted = ["abc": 456].asAnyPrefsStorageValues
    //     #expect(schema.anyDictDefaulted.count == 1)
    //     #expect(schema.anyDictDefaulted["abc"]?.unwrapped as? Int == 456)
    // }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func stringDictionaryDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringDictDefaulted.count == 2)
        #expect(schema.stringDictDefaulted["a"] == "123")
        #expect(schema.stringDictDefaulted["b"] == "456")
        
        schema.stringDictDefaulted = ["c": "789"]
        #expect(schema.stringDictDefaulted.count == 1)
        #expect(schema.stringDictDefaulted["c"] == "789")
    }
    
    // MARK: - Key names derived from variable names
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func x_atomicPrefKey(schema: TestSchema) async throws {
        #expect(schema.x_atomic == nil)
        
        schema.x_atomic = false
        #expect(schema.x_atomic == false)
        
        schema.x_atomic = true
        #expect(schema.x_atomic == true)
        
        schema.x_atomic?.toggle()
        #expect(schema.x_atomic == false)
        
        schema.x_atomic = nil
        #expect(schema.x_atomic == nil)
        
        // check storage for correct key name
        schema.x_atomic = true
        #expect(schema.storage.storageValue(forKey: "x_atomic") == true)
    }
}
