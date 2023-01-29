//
//  AuthenticationDataSource.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation
import Combine

protocol AuthenticationDataSourcing {
    var authReponse: AnyPublisher<AuthResponse, Never> { get }
    func authenticate(username: String, password: String) async throws
}

final class AuthenticationDataSource: AuthenticationDataSourcing {
    private var _response = PassthroughSubject<AuthResponse, Never>()
    var authReponse: AnyPublisher<AuthResponse, Never> { _response.eraseToAnyPublisher() }

    private let networkServicing: NetworkServicing

    init(networkServicing: NetworkServicing) {
        self.networkServicing = networkServicing
    }

    func authenticate(username: String, password: String) async throws {
        let body = try JSONEncoder().encode(["username": username, "password": password])
        let response: AuthResponse = try await networkServicing.fetch(PostRequest(body: body, path: "/tokens"))
        // Lucas: Persist here
        _response.send(response)
    }
}
