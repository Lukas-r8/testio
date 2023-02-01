//
//  MockAuthenticationDataSource.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

@testable import testio
import Combine

final class MockAuthenticationDataSource: AuthenticationDataSourcing {
    var _expectedAuthResponse = PassthroughSubject<AuthResponse?, Never>()
    var authReponse: AnyPublisher<AuthResponse?, Never> { _expectedAuthResponse.eraseToAnyPublisher() }

    var expectedFailure: AppError?

    private(set) var logoutCallCount = 0
    private(set) var authenticateCallCount = 0
    private(set) var authenticateCalledWith: [String]?

    func authenticate(username: String, password: String) async throws {
        authenticateCalledWith = [username, password]
        authenticateCallCount += 1
        if let expectedFailure { throw expectedFailure }
    }

    func logout() async throws {
        logoutCallCount += 1
        if let expectedFailure { throw expectedFailure }
    }
}
