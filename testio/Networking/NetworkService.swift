//
//  Networking.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol NetworkServicing {
    func send<T: Codable>(_ request: Request) async throws -> T
}

final class NetworkService<AuthRepo: Repository> where AuthRepo.Element == AuthResponse? {
    private let apiClient: APIClientInterface
    private let authRepository: AuthRepo

    private var auth: AuthResponse?

    init(authRepository: AuthRepo, apiClient: APIClientInterface = APIClient()) {
        self.authRepository = authRepository
        self.apiClient = apiClient
    }
}

extension NetworkService: NetworkServicing {
    func send<T: Codable>(_ request: Request) async throws -> T {
        if let authResponse = try? await authRepository.fetch() {
            apiClient.setToken(authResponse.token)
        }

        return try await apiClient.send(request)
    }
}
