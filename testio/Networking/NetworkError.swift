//
//  NetworkError.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

enum NetworkError: LocalizedError {
    case unauthorized
    case badRequest
    case unknown(error: Error)

    var errorDescription: String? {
        switch self {
        case .unauthorized: return "Not Authorized"
        case .badRequest: return "Bad Request"
        case .unknown(let error): return error.localizedDescription
        }
    }
}
