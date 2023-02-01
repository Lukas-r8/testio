//
//  MockAuthRepository.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

@testable import testio

final class MockAuthRepository: Repository {
    typealias Element = AuthResponse?

    var expectedAuthResponse: AuthResponse?
    var expectedFailure: PersistenceError?

    private(set) var fetchCallCount = 0

    private(set) var saveCallCount = 0
    private(set) var saveCalledWith: AuthResponse?

    private(set) var deleteCallCount = 0

    func fetch() async throws -> testio.AuthResponse? {
        fetchCallCount += 1
        if let expectedFailure { throw expectedFailure }
        return expectedAuthResponse
    }

    func save(_ item: testio.AuthResponse?) async throws {
        saveCallCount += 1
        saveCalledWith = item
        if let expectedFailure { throw expectedFailure }
    }

    func delete(_ item: testio.AuthResponse?) async throws {
        deleteCallCount += 1
        if let expectedFailure { throw expectedFailure }
    }
}
