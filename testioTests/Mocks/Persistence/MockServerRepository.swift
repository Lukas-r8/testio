//
//  MockServerRepository.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

@testable import testio

final class MockServerRepository: Repository {
    typealias Element = [Server]

    var expectedResponse: [Server] = []
    var expectedFailure: PersistenceError?

    private(set) var fetchCallCount = 0

    private(set) var saveCallCount = 0
    private(set) var saveCalledWith: [Server]?

    private(set) var deleteCallCount = 0

    func fetch() async throws -> [Server] {
        fetchCallCount += 1
        if let expectedFailure { throw expectedFailure }
        return expectedResponse
    }

    func save(_ item: [Server]) async throws {
        saveCallCount += 1
        saveCalledWith = item
        if let expectedFailure { throw expectedFailure }
    }

    func delete(_ item: [Server]) async throws {
        deleteCallCount += 1
        if let expectedFailure { throw expectedFailure }
    }
}
