//
//  ServerRepositoryTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio

final class ServerRepositoryTests: XCTestCase {
    private var sut: ServerRepository!
    private var coreDataStack: CoreDataStack!

    private let mockServers = [Server(name: "test1", distance: 123),
                               Server(name: "test2", distance: 456),
                               Server(name: "test3", distance: 789)]

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(inMemory: true)
        sut = ServerRepository(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        coreDataStack = nil
    }

    func testThatRepositorySavesEntities() async throws {
        try await sut.save(mockServers)
        let fetched = try await coreDataStack.read(ServerEntity.fetchRequest(),
                                                   parse: { Server(name: $0.name, distance: $0.distance) })
        XCTAssertEqual(mockServers, fetched.sorted { $0.name < $1.name })
    }

    func testThatRepositoryDeleteEntities() async throws {
        try await sut.save(mockServers)
        let serversToDelete = [mockServers[0], mockServers[2]]
        try await sut.delete(serversToDelete)

        let fetched = try await coreDataStack.read(ServerEntity.fetchRequest(),
                                                   parse: { Server(name: $0.name, distance: $0.distance) })
        XCTAssertEqual(fetched, [mockServers[1]])
    }

    func testThatRepositoryFetchesEntities() async throws {
        try await sut.save(mockServers)
        let fetched = try await sut.fetch()
        XCTAssertEqual(mockServers, fetched.sorted { $0.name < $1.name })
    }

    func testThatRepositoryUpdatesEntities() async throws {
        try await sut.save(mockServers)

        let fetchedBeforeUpdate = try await sut.fetch()

        let updatedServers = mockServers.map { Server(name: $0.name, distance: 999) }
        try await sut.save(updatedServers)

        let fetchedAfterUpdate = try await sut.fetch()

        XCTAssertEqual(fetchedBeforeUpdate.sorted { $0.name < $1.name }, mockServers)
        XCTAssertEqual(fetchedAfterUpdate.sorted { $0.name < $1.name } , updatedServers)
    }
}
