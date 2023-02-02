//
//  ServerDataSource.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol ServerDataSourcing {
    func fetchList(forceRefresh: Bool) async throws -> [Server]
}

final class ServerDataSource<ServerRepo: Repository>: ServerDataSourcing, ErrorMapper where ServerRepo.Element == [Server] {
    private var cache = [Server]()

    private let networkServicing: NetworkServicing
    private let serverRepository: ServerRepo

    init(networkServicing: NetworkServicing, serverRepository: ServerRepo) {
        self.networkServicing = networkServicing
        self.serverRepository = serverRepository
    }

    func fetchList(forceRefresh: Bool) async throws -> [Server] {
        do {
            guard forceRefresh || cache.isEmpty else { return cache }
            let storedItems = try await serverRepository.fetch()
            guard forceRefresh || storedItems.isEmpty else {
                self.cache = storedItems
                return storedItems
            }
            let downloadedItems: [Server] = try await networkServicing.send(GetRequest(path: "/servers"))
            try await serverRepository.delete(storedItems)
            try await serverRepository.save(downloadedItems)
            self.cache = downloadedItems
            return downloadedItems
        } catch {
            throw mapError(error)
        }
    }
}
