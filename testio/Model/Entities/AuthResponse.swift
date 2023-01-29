//
//  Authentication.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

struct AuthResponse: SecurelyPersistable {
    static let uniqueId: String = "testio.credentials.AuthResponse"
    let token: String
}
