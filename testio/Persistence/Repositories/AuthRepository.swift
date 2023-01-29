//
//  AuthRepository.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 29.01.23.
//

import Foundation

final class AuthRepository: Repository {
    typealias Element = AuthResponse?

    private let keychain: Keychain

    init(keychain: Keychain) {
        self.keychain = keychain
    }

    func fetch() throws -> AuthResponse? {
        do {
            return try keychain.fetch(AuthResponse.self)
        } catch {
            throw PersistenceError.fetchFailed
        }
    }

    func save(_ item: AuthResponse?) throws  {
        do {
            try keychain.save(item)
        } catch {
            throw PersistenceError.saveFailed
        }
    }

    func delete(_ item: AuthResponse?) throws {
        do {
            try keychain.delete(AuthResponse.self)
        } catch {
            throw PersistenceError.deleteFailed
        }
    }
}
