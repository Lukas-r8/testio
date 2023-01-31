//
//  KeychainError.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 30.01.23.
//

import Foundation

enum KeychainError: LocalizedError {
    case encodingFailed
    case saveFailed
    case deleteFailed
    case fetchFailed
    case notFound

    var errorDescription: String? {
        switch self {
        case .encodingFailed: return "Keychain: Could not encode credentials"
        case .saveFailed: return "Keychain: Something went wrong on save"
        case .deleteFailed: return "Keychain: Something went wrong on delete"
        case .fetchFailed: return "Keychain: Something went wrong on credential fetch"
        case .notFound: return "Keychain: Credential Not Found"
        }
    }
}
