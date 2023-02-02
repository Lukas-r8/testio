//
//  APIClientTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 02.02.23.
//

import XCTest
@testable import testio

final class APIClientTests: XCTestCase {
    private var sut: APIClient!
    private var requestSession: MockRequestSession!

    override func setUp() {
        super.setUp()
        requestSession = MockRequestSession()
        sut = APIClient(requestSession: requestSession)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        requestSession = nil
    }

    func testThatClientSendsRequest() async throws {
        requestSession.expectedData = #"[{"name": "testing", "distance": 8}]"#.data(using: .utf8)
        requestSession.expectedResponse = HTTPURLResponse(url: URL(string: "http://google.com")!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)

        sut.setToken("a.mock.token")

        let postRequest = PostRequest(body: "body_request".data(using: .utf8), path: "/test")
        let server: [Server] = try await sut.send(postRequest)

        XCTAssertEqual(server, [Server(name: "testing", distance: 8)])

        XCTAssertEqual(requestSession.dataForRequestCallCount, 1)
        XCTAssertEqual(requestSession.dataForRequestCalledWith?.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                                                      "Authorization": "Bearer a.mock.token"])
        XCTAssertEqual(requestSession.dataForRequestCalledWith?.url?.absoluteString, "https://playground.tesonet.lt/v1/test")
        XCTAssertEqual(String(data: requestSession.dataForRequestCalledWith!.httpBody!, encoding: .utf8), "body_request")
    }

    func testThatClientFailsWhenRequestFailsWithAnyError() async {
        requestSession.expectedData = #"[{"name": "testing", "distance": 8}]"#.data(using: .utf8)
        requestSession.expectedResponse = HTTPURLResponse(url: URL(string: "http://google.com")!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)

        requestSession.expectedFailure = NSError(domain: "test", code: 123)

        let postRequest = PostRequest(body: "body_request".data(using: .utf8), path: "/test")

        let thrownError = await XCTAssertThrowsAsync(try await {
            let response: [Server] = try await sut.send(postRequest)
            return response
        }(), ofType: NetworkError.self)

        XCTAssertEqual(thrownError, .unknown(description: "The operation couldn’t be completed. (test error 123.)"))
    }

    func testThatClientFailsWithAppropriateErrorForStatusCode() async {
        requestSession.expectedData = "".data(using: .utf8)
        var capturedErrors = [NetworkError]()

        let responses = makeMockHTTPResponses(for: [
            401, 403, 400, 500, 404, 999
        ])

        for httpResponse in responses {
            requestSession.expectedResponse = httpResponse

            let thrownError = await XCTAssertThrowsAsync(try await {
                let response: [Server] = try await sut.send(PostRequest(body: "body_request".data(using: .utf8), path: "/test"))
                return response
            }(), ofType: NetworkError.self)

            capturedErrors.append(thrownError!)
        }

        let expectedErrors: [NetworkError] = [
            .unauthorized,
            .unauthorized,
            .badRequest,
            .serverError,
            .notFound,
            .unknown(description: "Failed with status code 999")
        ]

        XCTAssertEqual(capturedErrors, expectedErrors)
    }
}

private extension APIClientTests {
    func makeMockHTTPResponses(for statusCodes: [Int]) -> [HTTPURLResponse] {
        statusCodes.map {
            HTTPURLResponse(url: URL(string: "http://google.com")!,
                            statusCode: $0,
                            httpVersion: nil,
                            headerFields: nil)!
        }
    }
}
