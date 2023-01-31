//
//  ServerRepository.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 29.01.23.
//

import Foundation
import CoreData

final class ServerRepository: Repository {
    typealias Element = [Server]

    private let stack: CoreDataStack

    init(stack: CoreDataStack) {
        self.stack = stack
    }

    func fetch() async throws -> [Server] {
        return try await stack.read(ServerEntity.fetchRequest()) { Server(name: $0.name, distance: $0.distance) }
    }

    func save(_ item: [Server]) async throws  {
        try await stack.write { context in
            try item.forEach { server in
                let serverEntity = try context.fetch(ServerEntity.fetchBy(name: server.name)).first ?? ServerEntity(context: context)
                serverEntity.name = server.name
                serverEntity.distance = server.distance
            }
        }
    }

    func delete(_ item: [Server]) async throws {
        try await stack.delete(ServerEntity.deleteRequest(for: item.map(\.name)))
    }
}
