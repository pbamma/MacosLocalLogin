//
//  KeychainManager.swift
//  MacosLocalLogin
//
//  Created by Philip Starner on 11/26/19.
//  Copyright © 2019 Philip Starner. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

/**
    KeychainManager uses the singleton design pattern so as to be used across app without
 any unnecessary object creation.
 */
class KeychainManager {
    static let shared = KeychainManager()
    /** securityServiceName - that which can be found in the keychain after a new key\pass has been saved. */
    static let securityServiceName = "MacosLocalLogin.philipstarner.com"
    
    /** private constructor to prevent multiple instances. */
    private init() {}
    
    /**
        Save a username and password to the Mac keychain using KeychainManager.securityServiceName
     - Parameter userName: the username to be saved
     - Parameter password: the password to be saved
     */
    func saveToKeychain(userName: String, password: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: userName,
                                    kSecAttrService as String : KeychainManager.securityServiceName,
                                    kSecValueData as String: password]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status)}
    }
    
    /**
        Lookup a single userName and compare input password to keychain password
     - Parameter userName: the username to be looked up
     - Parameter password: the password to be cmpared against lookup
     - Returns: Bool true if password mateches lookup
     - Throws: KeychainError.unhandledError, unexpectedPasswordData
     */
    func loginFromKeychain(userName: String, password: String) throws {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: userName,
                                    kSecAttrService as String : KeychainManager.securityServiceName,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue as Any]
        
        var dataTypeRef :AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        // Search for the keychain items
        var contentsOfKeychain: String?

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
                if contentsOfKeychain != password {
                    throw KeychainError.unexpectedPasswordData
                }
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
            throw KeychainError.unhandledError(status: status)
        }
        
    }
    
    /**
        Removes a username and password from the Mac keychain using KeychainManager.securityServiceName
     - Throws: KeychainError.unhandledError
     */
    func removeFromKeychain() throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String : KeychainManager.securityServiceName]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status)}
    }
    
}
