//
//  AuthenticationDataSource.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol AuthenticationDataSourcing {
    func authenticate(username: String, password: String) async throws
}

final class AuthenticationDataSource: AuthenticationDataSourcing {
    private let networkServicing: NetworkServicing

    init(networkServicing: NetworkServicing) {
        self.networkServicing = networkServicing
    }

    func authenticate(username: String, password: String) async throws {
        let body = try JSONEncoder().encode(["username": username, "password": password])
        let response: AuthResponse = try await networkServicing.fetch(PostRequest(body: body, path: "/tokens"))
        // Lucas: Persist here
        print(response.token)
    }
}
