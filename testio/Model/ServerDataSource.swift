//
//  ServerDataSource.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class ServerDataSource {
    private let networkServicing: NetworkServicing

    init(networkServicing: NetworkServicing) {
        self.networkServicing = networkServicing
    }

    func fetchList() async throws -> [Server] {
        return try await networkServicing.fetch(GetRequest(path: "/servers"))
    }
}
