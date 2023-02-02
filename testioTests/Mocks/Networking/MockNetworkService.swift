//
//  MockNetworkService.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

@testable import testio

final class MockNetworkService<Result: Codable>: NetworkServicing {
    private(set) var fetchCallCount = 0
    private(set) var fetchCalledWith: Request?

    var expectedFetchResult: Result?
    var expectedFailure: NetworkError?

    func send<T: Codable>(_ request: Request) async throws -> T {
        fetchCallCount += 1
        fetchCalledWith = request

        if let expectedFailure { throw expectedFailure }

        return expectedFetchResult as! T
    }
}
