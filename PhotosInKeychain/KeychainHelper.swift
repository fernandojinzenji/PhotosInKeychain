//
//  KeychainHelper.swift
//  PhotosInKeychain
//
//  Created by Fernando Jinzenji on 2018-11-13.
//  Copyright © 2018 Fernando Jinzenji. All rights reserved.
//

import Foundation
import Security

class KeychainHelper {
    
    /// Contains result code from the last operation. Value is noErr (0) for a successful result.
    var lastResultCode: OSStatus = noErr
    
    init() {
        
    }
    
    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool {
        
        if let value = value.data(using: String.Encoding.utf8) {
            return set(value, forKey: key)
        }
        
        return false
    }
    
    @discardableResult
    func set(_ value: Data, forKey key: String) -> Bool {
        
        delete(key) // Delete any existing key before saving it
        
        let accessible = kSecAttrAccessibleWhenUnlocked as String
        
        let query: [String : Any] = [
            kSecClass as String             : kSecClassGenericPassword,
            kSecAttrAccount as String       : key,
            kSecValueData as String         : value,
            kSecAttrAccessible as String    : accessible
        ]
        
        lastResultCode = SecItemAdd(query as CFDictionary, nil)
        
        return lastResultCode == noErr
    }
    
    @discardableResult
    func get(_ key: String) -> String? {
        if let data = getData(key) {
            
            if let currentString = String(data: data, encoding: .utf8) {
                return currentString
            }
            
            lastResultCode = -67853 // errSecInvalidEncoding
        }
        
        return nil
    }
    
    @discardableResult
    func getData(_ key: String) -> Data? {
        
        let query: [String: Any] = [
            kSecClass as String             : kSecClassGenericPassword,
            kSecAttrAccount as String       : key,
            kSecReturnData as String        : kCFBooleanTrue,
            kSecMatchLimit as String        : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if lastResultCode == noErr { return result as? Data }
        
        return nil
    }
    
    @discardableResult
    func delete(_ key: String) -> Bool {
        
        let query: [String: Any] = [
            kSecClass as String             : kSecClassGenericPassword,
            kSecAttrAccount as String       : key
        ]
        
        lastResultCode = SecItemDelete(query as CFDictionary)
        
        return lastResultCode == noErr
    }
}
