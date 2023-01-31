//
//  PersistenceFailure.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 30.01.23.
//

import Foundation

enum PersistenceError: LocalizedError, Equatable {
    case saveFailed(reason: String)
    case fetchFailed(reason: String)
    case deleteFailed(reason: String)
    case unknown(reason: String)

    init(keychainError: KeychainError) {
        switch keychainError {
        case .encodingFailed, .saveFailed: self = .saveFailed(reason: keychainError.localizedDescription)
        case .deleteFailed: self = .deleteFailed(reason: keychainError.localizedDescription)
        case .fetchFailed, .notFound: self = .fetchFailed(reason: keychainError.localizedDescription)
        }
    }

    init(coredataError: CoreDataError) {
        switch coredataError {
        case .saveFailed: self = .saveFailed(reason: coredataError.localizedDescription)
        case .deleteFailed, .clearFailed: self = .deleteFailed(reason: coredataError.localizedDescription)
        case .fetchFailed: self = .fetchFailed(reason: coredataError.localizedDescription)
        }
    }

    var errorDescription: String? {
        switch self {
        case .saveFailed(let reason),
             .fetchFailed(let reason),
             .deleteFailed(let reason),
             .unknown(let reason):
            return reason
        }
    }
}
