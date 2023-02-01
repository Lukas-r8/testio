//
//  MockServerDataSource.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

@testable import testio
import Combine

final class MockServerDataSource: ServerDataSourcing {
    private(set) var fetchListCallCount = 0
    private(set) var fetchListCalledWith: Bool?

    var expectedResponse: [Server] = []
    var expectedFailure: AppError?

    func fetchList(forceRefresh: Bool) async throws -> [Server] {
        fetchListCallCount += 1
        fetchListCalledWith = forceRefresh
        if let expectedFailure { throw expectedFailure }
        return expectedResponse
    }
}
