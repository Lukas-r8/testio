//
//  Networking.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol NetworkServicing {
    func fetch<T: Codable>(_ request: Request) async throws -> T
}

final class NetworkService {
    let apiClient = APIClient()
    let tokenRepository

    init(tokenRepository: Repository) {
        
    }
}

extension NetworkService: NetworkServicing {
    func fetch<T: Codable>(_ request: Request) async throws -> T {
        apiClient.setToken("token")
        return try await apiClient.send(request)
    }
}
