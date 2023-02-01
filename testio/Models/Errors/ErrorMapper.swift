//
//  ErrorMapper.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import Foundation

protocol ErrorMapper {
    func mapError(_ error: Error) -> AppError
}

extension ErrorMapper {
    func mapError(_ error: Error) -> AppError {
        switch error {
        case let error as NetworkError: return .network(error)
        case let error as PersistenceError: return .persistence(error)
        case let error as CoreDataError: return .persistence(PersistenceError(coredataError: error))
        case let error as KeychainError: return .persistence(PersistenceError(keychainError: error))
        case let error as AppError: return error
        default: return .unknown(description: error.localizedDescription)
        }
    }
}
