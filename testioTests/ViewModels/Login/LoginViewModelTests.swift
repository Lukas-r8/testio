//
//  LoginViewModel.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio
import Combine

final class LoginViewModelTests: XCTestCase {
    private var sut: LoginViewModel!
    private var authenticationDataSource: MockAuthenticationDataSource!
    private var navigator: MockRootCoordinator!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        authenticationDataSource = MockAuthenticationDataSource()
        navigator = MockRootCoordinator()
        sut = LoginViewModel(authenticationDataSource: authenticationDataSource, navigator: navigator)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        authenticationDataSource = nil
        navigator = nil
        cancellables = Set()
    }

    func testThatLoginSucceeds() async throws {
        sut.username = "mock_user"
        sut.password = "mock_password"
        await sut.login()

        XCTAssertEqual(authenticationDataSource.authenticateCallCount, 1)
        XCTAssertEqual(authenticationDataSource.authenticateCalledWith, ["mock_user", "mock_password"])
        XCTAssertEqual(navigator.loggedInCallCount, 1)
    }

    func testThatLoginPresentsErrorWhenAuthenticationFails() async throws {
        authenticationDataSource.expectedFailure = .network(.unauthorized)
        sut.username = "mock_user"
        sut.password = "mock_password"
        await sut.login()

        XCTAssertEqual(authenticationDataSource.authenticateCallCount, 1)
        XCTAssertEqual(authenticationDataSource.authenticateCalledWith, ["mock_user", "mock_password"])
        XCTAssertEqual(navigator.loggedInCallCount, 0)

        XCTAssertEqual(navigator.presentAlertCallCount, 1)
        XCTAssertEqual(navigator.presentAlertCalledWith!.title, "Verification Failed")
        XCTAssertEqual(navigator.presentAlertCalledWith!.message, "Your username or password is incorrect.")
    }

    func testThatLoadingStateIsProperlyUpdated() async throws {
        sut.username = "mock_user"
        sut.password = "mock_password"

        let expectation = expectation(description: #function)
        sut.$loading
            .dropFirst()
            .collect(2)
            .sink { states in
                XCTAssertEqual(states, [true, false])
                expectation.fulfill()
            }.store(in: &cancellables)

        await sut.login()
        await waitForExpectations(timeout: 1)
    }
}
