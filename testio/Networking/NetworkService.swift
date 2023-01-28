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
    let tokenRepository: Repository

    init(tokenRepository: Repository) {
        self.tokenRepository = tokenRepository
    }
}

extension NetworkService: NetworkServicing {
    func fetch<T: Codable>(_ request: Request) async throws -> T {
//        apiClient.setToken("token")
        return try await apiClient.send(request)
    }
}
