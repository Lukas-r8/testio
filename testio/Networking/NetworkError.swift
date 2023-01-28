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
    case unknown(description: String)

    var errorDescription: String? {
        switch self {
        case .unauthorized: return "Not Authorized"
        case .badRequest: return "Bad Request"
        case .unknown(let description): return description
        }
    }
}
