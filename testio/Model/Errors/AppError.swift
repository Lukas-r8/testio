//
//  AppError.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 30.01.23.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case persistence(PersistenceError)
    case network(NetworkError)
    case unknown(description: String)

    var errorTitle: String {
        guard case .network(.unauthorized) = self else { return "Error" }
        return "Verification Failed"
    }

    var errorDescription: String? {
        switch self {
        case .persistence(let failure): return failure.localizedDescription
        case .network(let failure): return failure.localizedDescription
        case .unknown(let description): return description
        }
    }
}
