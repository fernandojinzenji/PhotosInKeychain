//
//  KeychainHelper.swift
//  PhotosInKeychain
//
//  Created by Fernando Jinzenji on 2018-11-13.
//  Copyright © 2018 Fernando Jinzenji. All rights reserved.
//

import Foundation
import Security
import UIKit

class KeychainHelper {
    
    /// Contains result code from the last operation. Value is noErr (0) for a successful result.
    var lastResultCode: OSStatus = noErr
    
    let uuidListKey = "Photos"
    
    init() {
        
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
    
    @discardableResult
    func clear() -> Bool {
        let query: [String: Any] = [ kSecClass as String : kSecClassGenericPassword ]
        
        lastResultCode = SecItemDelete(query as CFDictionary)
        
        return lastResultCode == noErr
    }
    
    func getImageUuids() -> [String] {
        
        guard let rawData = getData(uuidListKey) else { return [] }
        
        do {
            if let uuids = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData) as? [String] {
                
                return uuids
            } else {
                return []
            }
            
        }
        catch {
            return []
        }
    }
    
    func getImage(uuid: String) -> UIImage? {
        
        guard let data = getData(uuid) else { return nil }        
        return UIImage(data: data)
    }
}
