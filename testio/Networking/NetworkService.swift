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

final class NetworkService<AuthRepo: Repository> where AuthRepo.Element == AuthResponse? {
    private let apiClient = APIClient()
    private let authRepository: AuthRepo

    private var auth: AuthResponse?

    init(authRepository: AuthRepo) {
        self.authRepository = authRepository
    }
}

extension NetworkService: NetworkServicing {
    func fetch<T: Codable>(_ request: Request) async throws -> T {
        if let authResponse = try? await authRepository.fetch() {
            apiClient.setToken(authResponse.token)
        }

        return try await apiClient.send(request)
    }
}
