//
//  MockAPIClient.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 02.02.23.
//

@testable import testio

final class MockAPIClient<Response: Codable>: APIClientInterface {
    private(set) var sendCallCount = 0
    private(set) var sendCalledWith: Request?

    private(set) var setTokenCallCount = 0
    private(set) var setTokenCalledWith: String?

    var expectedResponse: Response?
    var expectedFailure: NetworkError?

    func send<T: Codable>(_ request: Request) async throws -> T {
        print("calling mock api🧠")
        sendCallCount += 1
        sendCalledWith = request
        if let expectedFailure {
            throw expectedFailure
        }
        return expectedResponse as! T
    }

    func setToken(_ token: String?) {
        setTokenCallCount += 1
        setTokenCalledWith = token
    }
}
