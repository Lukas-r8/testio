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

final class AuthenticationDataSource<AuthRepo: Repository>: AuthenticationDataSourcing, ErrorMapper where AuthRepo.Element == AuthResponse? {
    typealias ClearDatabaseHandler = () async throws -> Void
    private var _response = CurrentValueSubject<AuthResponse?, Never>(nil)

    private let networkServicing: NetworkServicing
    private let authRepository: AuthRepo
    private let clearDatabase: ClearDatabaseHandler

    var authReponse: AnyPublisher<AuthResponse?, Never> { _response.eraseToAnyPublisher() }

    init(networkServicing: NetworkServicing, authRepository: AuthRepo, clearDatabase: @escaping ClearDatabaseHandler) {
        self.networkServicing = networkServicing
        self.authRepository = authRepository
        self.clearDatabase = clearDatabase

        Task {
            let authData = try await self.authRepository.fetch()
            _response.send(authData)
        }
    }

    func authenticate(username: String, password: String) async throws {
        do {
            let body = try JSONEncoder().encode(["username": username, "password": password])
            let response: AuthResponse = try await networkServicing.send(PostRequest(body: body, path: "/tokens"))
            try await authRepository.save(response)
            _response.send(response)
        } catch {
            throw mapError(error)
        }
    }

    func logout() async throws {
        do {
            try await authRepository.delete(nil)
            try await clearDatabase()
            _response.send(nil)
        } catch {
            throw mapError(error)
        }
    }
}
