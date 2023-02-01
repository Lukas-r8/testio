//
//  AuthenticationDataSourceTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio
import Combine

final class AuthenticationDataSourceTests: XCTestCase {
    private var sut: AuthenticationDataSource<MockAuthRepository>!
    private var repository: MockAuthRepository!
    private var networkService: MockNetworkService<AuthResponse>!
    private var clearDatabaseCallCount = 0
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        repository = MockAuthRepository()
        networkService = MockNetworkService()
        sut = AuthenticationDataSource(networkServicing: networkService,
                                       authRepository: repository,
                                       clearDatabase: { [unowned self] in clearDatabaseCallCount += 1 })
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        repository = nil
        networkService = nil
        clearDatabaseCallCount = 0
        cancellables = Set<AnyCancellable>()
    }

    func testThatAuthenticationSucceeds() async throws {
        let mockAuthReponse = AuthResponse(token: "a.mock.reponse.token")

        networkService.expectedFetchResult = mockAuthReponse

        try await sut.authenticate(username: "mock_user", password: "mock_password")

        XCTAssertEqual(repository.saveCallCount, 1)
        XCTAssertEqual(repository.saveCalledWith, mockAuthReponse)

        XCTAssertEqual(networkService.fetchCallCount, 1)

        let postRequest = networkService.fetchCalledWith as! PostRequest
        XCTAssertEqual(postRequest.method, .post)
        XCTAssertEqual(postRequest.path, "/tokens")

        let decodedRequestBody = try JSONDecoder().decode([String: String].self, from: postRequest.body!)
        XCTAssertEqual(decodedRequestBody["username"], "mock_user")
        XCTAssertEqual(decodedRequestBody["password"], "mock_password")
    }

    func testThatAuthenticationFailsIfNetworkFailureOccurs() async throws {
        networkService.expectedFailure = .badRequest

        let errorThrown = await XCTAssertThrowsAsync(try await sut.authenticate(username: "mock_user", password: "mock_password"),
                                                     ofType: AppError.self)

        XCTAssertEqual(errorThrown, .network(.badRequest))
    }

    func testThatAuthenticationFailsIfPersistenceFailureOccurs() async throws {
        let mockAuthReponse = AuthResponse(token: "a.mock.reponse.token")
        networkService.expectedFetchResult = mockAuthReponse

        repository.expectedFailure = .saveFailed(reason: "mock reason!")

        let errorThrown = await XCTAssertThrowsAsync(try await sut.authenticate(username: "mock_user", password: "mock_password"),
                                                     ofType: AppError.self)

        XCTAssertEqual(errorThrown, .persistence(.saveFailed(reason: "mock reason!")))
    }

    func testThatLogoutSucceeds() async throws {
        let expectation = expectation(description: #function)
        sut.authReponse
            .dropFirst()
            .sink { response in
                XCTAssertEqual(response, nil)
                expectation.fulfill()
            }.store(in: &cancellables)

        try await sut.logout()
        await waitForExpectations(timeout: 1)

        XCTAssertEqual(repository.deleteCallCount, 1)
        XCTAssertEqual(clearDatabaseCallCount, 1)
    }

    func testThatLogoutFails() async throws {
        repository.expectedFailure = .deleteFailed(reason: "mock delete reason!")

        let errorThrown = await XCTAssertThrowsAsync(try await sut.logout(), ofType: AppError.self)

        XCTAssertEqual(errorThrown, .persistence(.deleteFailed(reason: "mock delete reason!")))
    }
}
