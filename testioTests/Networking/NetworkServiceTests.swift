//
//  NetworkServiceTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio

final class NetworkServiceTests: XCTestCase {
    private var sut: NetworkService<MockAuthRepository>!
    private var authRepository: MockAuthRepository!
    private var apiClient: MockAPIClient<[Server]>!

    override func setUp() {
        super.setUp()
        authRepository = MockAuthRepository()
        apiClient = MockAPIClient()
        sut = NetworkService(authRepository: authRepository, apiClient: apiClient)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        authRepository = nil
        apiClient = nil
    }

    func testThatSendRequestSucceeds() async throws {
        apiClient.expectedResponse = [Server(name: "test", distance: 1)]
        authRepository.expectedAuthResponse = AuthResponse(token: "mock_token")

        let mockBody = try JSONEncoder().encode("mock_request_body")
        let response: [Server] = try await sut.send(PostRequest(body: mockBody, path: "/mock"))

        XCTAssertEqual(response, [Server(name: "test", distance: 1)])
        XCTAssertEqual(authRepository.fetchCallCount, 1)

        XCTAssertEqual(apiClient.sendCallCount, 1)

        let sendRequest = apiClient.sendCalledWith as! PostRequest
        XCTAssertEqual(sendRequest.method, .post)
        XCTAssertEqual(sendRequest.path, "/mock")
        XCTAssertEqual(try JSONDecoder().decode(String.self, from: sendRequest.body!), "mock_request_body")

        XCTAssertEqual(apiClient.setTokenCallCount, 1)
        XCTAssertEqual(apiClient.setTokenCalledWith, "mock_token")
    }

    func testThatSendRequestFails() async {
        apiClient.expectedFailure = .unauthorized

        let mockBody = try! JSONEncoder().encode("mock_request_body")
        let postRequest = PostRequest(body: mockBody, path: "/mock")
        let errorThrown = await XCTAssertThrowsAsync(try await { [self] in
            let server: [Server] = try await self.sut.send(postRequest)
            return server
        }(), ofType: NetworkError.self)
        XCTAssertEqual(errorThrown, .unauthorized)
    }
}
