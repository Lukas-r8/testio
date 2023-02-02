//
//  MockRequestSession.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 02.02.23.
//

@testable import testio
import Foundation

final class MockRequestSession: RequestSession {
    private(set) var dataForRequestCallCount = 0
    private(set) var dataForRequestCalledWith: URLRequest?

    var expectedData: Data!
    var expectedResponse: URLResponse!
    var expectedFailure: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataForRequestCallCount += 1
        dataForRequestCalledWith = request
        if let expectedFailure { throw expectedFailure }
        return (expectedData, expectedResponse)
    }
}
