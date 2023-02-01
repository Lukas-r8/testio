//
//  CoreDataStackTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio

final class CoreDataStackTests: XCTestCase {
    private var sut: CoreDataStack!

    private let mockServers = [Server(name: "test1", distance: 123),
                               Server(name: "test2", distance: 456),
                               Server(name: "test3", distance: 789)]

    override func setUp() {
        super.setUp()
        self.sut = CoreDataStack(inMemory: true)
    }

    override func tearDown() {
        super.tearDown()
        self.sut = nil
    }

    func testThatWriteSucceeds() async throws {
        try await sut.write { [unowned self] context in
            mockServers.forEach { server in
                let serverEntity = ServerEntity(context: context)
                serverEntity.name = server.name
                serverEntity.distance = server.distance
            }
        }

        try await sut.backgroundContext.perform { [unowned self] in
            let fetchedServers = try sut.backgroundContext.fetch(ServerEntity.fetchRequest()).sorted { $0.name < $1.name }
            for index in 0 ..< mockServers.count {
                XCTAssertEqual(mockServers[index].name, fetchedServers[index].name)
                XCTAssertEqual(mockServers[index].distance, fetchedServers[index].distance)
            }
        }
    }

    func testThatReadSucceeds() async throws {
        try await sut.backgroundContext.perform { [unowned self] in
            mockServers.forEach { server in
                let serverEntity = ServerEntity(context: sut.backgroundContext)
                serverEntity.name = server.name
                serverEntity.distance = server.distance
            }
            try sut.backgroundContext.save()
        }

        let fetchedServers = try await sut.read(ServerEntity.fetchRequest(), parse: { entity in
            Server(name: entity.name, distance: entity.distance)
        }).sorted { $0.name < $1.name }

        XCTAssertEqual(mockServers, fetchedServers)
    }

    func testThatDeleteSucceeds() async throws {
        try await sut.backgroundContext.perform { [unowned self] in
            mockServers.forEach { server in
                let serverEntity = ServerEntity(context: sut.backgroundContext)
                serverEntity.name = server.name
                serverEntity.distance = server.distance
            }
            try sut.backgroundContext.save()
        }

        try await sut.delete(ServerEntity.deleteRequest(for: ["test1", "test2"]))

        let fetchedServers = try await sut.mainContext.perform { [unowned self] in
            try sut.mainContext.fetch(ServerEntity.fetchRequest())
        }.sorted { $0.name < $1.name }

        XCTAssertEqual(fetchedServers.count, 1)
        XCTAssertEqual(fetchedServers[0].name, mockServers[2].name)
    }

    func testThatClearSucceeds() async throws {
        try await sut.backgroundContext.perform { [unowned self] in
            mockServers.forEach { server in
                let serverEntity = ServerEntity(context: sut.backgroundContext)
                serverEntity.name = server.name
                serverEntity.distance = server.distance
            }
            try sut.backgroundContext.save()
        }

        try await sut.clear()

        let fetchedServers = try await sut.mainContext.perform { [unowned self] in
            try sut.mainContext.fetch(ServerEntity.fetchRequest())
        }

        XCTAssertEqual(fetchedServers, [])
    }
}
