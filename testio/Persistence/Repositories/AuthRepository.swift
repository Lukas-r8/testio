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
        return try keychain.fetch(AuthResponse.self)
    }

    func save(_ item: AuthResponse?) throws  {
        try keychain.save(item)
    }

    func delete(_ item: AuthResponse?) throws {
        try keychain.delete(AuthResponse.self)
    }
}
