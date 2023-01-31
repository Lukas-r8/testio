//
//  NetworkError.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case unauthorized
    case badRequest
    case notFound
    case serverError
    case unknown(description: String)

    var errorDescription: String? {
        switch self {
        case .unauthorized: return "Your username or password is incorrect."
        case .badRequest: return "Something went wrong with the request."
        case .notFound: return "Data not found."
        case .serverError: return "Something went wrong on our servers."
        case .unknown(let description): return description
        }
    }
}
