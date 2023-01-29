//
//  AuthenticationDataSource.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation
import Combine

protocol AuthenticationDataSourcing {
    var authReponse: AnyPublisher<AuthResponse?, Never> { get }
    func authenticate(username: String, password: String) async throws
    func logout() async throws
}

final class AuthenticationDataSource<AuthRepo: Repository>: AuthenticationDataSourcing where AuthRepo.Element == AuthResponse? {
    private var _response = CurrentValueSubject<AuthResponse?, Never>(nil)
    var authReponse: AnyPublisher<AuthResponse?, Never> { _response.eraseToAnyPublisher() }

    private let networkServicing: NetworkServicing
    private let authRepository: AuthRepo

    init(networkServicing: NetworkServicing, authRepository: AuthRepo) {
        self.networkServicing = networkServicing
        self.authRepository = authRepository

        Task {
            let authData = try await self.authRepository.fetch()
            _response.send(authData)
        }
    }

    func authenticate(username: String, password: String) async throws {
        let body = try JSONEncoder().encode(["username": username, "password": password])
        let response: AuthResponse = try await networkServicing.fetch(PostRequest(body: body, path: "/tokens"))
        try await authRepository.save(response)
        _response.send(response)
    }

    func logout() async throws {
        try await authRepository.delete(nil)
        _response.send(nil)
    }
}
