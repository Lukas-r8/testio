//
//  RootCoordinatorTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio

final class RootCoordinatorTests: XCTestCase {
    private var sut: RootCoordinator!
    private var container = DataSourceContainer(networkService: MockNetworkService<[Server]>(),
                                                coredataStack: CoreDataStack(inMemory: true),
                                                keychain: .default)

    override func setUp() {
        super.setUp()
        sut = RootCoordinator(dataSourceContainer: container)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testThatLoginAndLogoutSucceeds() {
        XCTAssertNil(sut.serverListViewModel)

        sut.loggedIn()
        XCTAssertNotNil(sut.serverListViewModel)

        sut.loggedOut()
        XCTAssertNil(sut.serverListViewModel)
    }

    func testThatPresentDialogSucceeds() {
        XCTAssertNil(sut.dialog)
        sut.present(dialog: AlertingItem(title: "mock"))
        XCTAssertNotNil(sut.dialog)
    }

    func testThatPresentAlertSucceeds() {
        XCTAssertNil(sut.alert)
        sut.present(alert: AlertingItem(title: "mock"))
        XCTAssertNotNil(sut.alert)
    }
}
