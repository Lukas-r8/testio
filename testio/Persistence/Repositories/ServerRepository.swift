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
        do {
            return try await stack.read(ServerEntity.fetchRequest()) { Server(name: $0.name, distance: $0.distance) }
        } catch {
            throw PersistenceError.fetchFailed
        }
    }

    func save(_ item: [Server]) async throws  {
        do {
            try await stack.write { context in
                item.forEach { server in
                    let serverEntity = ServerEntity(context: context)
                    serverEntity.name = server.name
                    serverEntity.distance = server.distance
                }
            }
        } catch {
            throw PersistenceError.saveFailed
        }
    }

    func delete(_ item: [Server]) async throws {
        do {
            try await stack.delete(ServerEntity.deleteRequest(for: item.map(\.name)))
        } catch {
            throw PersistenceError.deleteFailed
        }
    }
}
