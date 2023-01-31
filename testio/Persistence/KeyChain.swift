//
//  KeyChain.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class Keychain {
    static let `default` = Keychain()
    private let service = "lucas.testio.credentials"

    private init() {
        guard !appHasFirstLaunched else { return }
        appHasFirstLaunched = true
        wipe()
    }

    func save<Entity: SecurelyPersistable>(_ entity: Entity) throws {
        guard let data = try? PropertyListEncoder().encode(entity) else { throw KeychainError.encodingFailed }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: Entity.uniqueId,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else { throw KeychainError.saveFailed }
    }

    func delete<Entity: SecurelyPersistable>(_ entity: Entity.Type) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Entity.uniqueId,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed
        }
    }

    func fetch<Entity: SecurelyPersistable>(_ entity: Entity.Type) throws -> Entity {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: Entity.uniqueId,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue as Any,
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else {
            throw KeychainError.notFound
        }

        guard let data = item as? Data, status == errSecSuccess else {
            throw KeychainError.fetchFailed
        }

        return try PropertyListDecoder().decode(Entity.self, from: data)
    }

    func wipe() {
        let secItemClasses = [kSecClassGenericPassword,
                              kSecClassInternetPassword,
                              kSecClassCertificate,
                              kSecClassKey,
                              kSecClassIdentity]
        secItemClasses.forEach {
            let dictionary = [kSecClass as String: $0]
            SecItemDelete(dictionary as CFDictionary)
        }
    }
}

private extension Keychain {
    static let appHasFirstLauchedKey = "app_has_first_launched"

    var appHasFirstLaunched: Bool {
        get { UserDefaults.standard.bool(forKey: Keychain.appHasFirstLauchedKey) }
        set { UserDefaults.standard.set(newValue, forKey: Keychain.appHasFirstLauchedKey) }
    }
}
