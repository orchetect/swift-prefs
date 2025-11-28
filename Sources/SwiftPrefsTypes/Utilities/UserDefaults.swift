//
//  UserDefaults.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaults {
    func removeAllKeys() {
        let keys = dictionaryRepresentation().keys
        for key in keys {
            removeObject(forKey: key)
        }
    }
    
    func merge(_ contents: [String: Any]) {
        for element in contents {
            set(element.value, forKey: element.key)
        }
    }
}
