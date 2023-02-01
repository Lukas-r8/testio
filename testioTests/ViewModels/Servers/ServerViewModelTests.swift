//
//  ServerViewModelTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio
import Combine

final class ServerViewModelTests: XCTestCase {
    private var sut: ServerListViewModel!
    private var serverDataSource: MockServerDataSource!
    private var authenticationDatasource: MockAuthenticationDataSource!
    private var navigator: MockRootCoordinator!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        serverDataSource = MockServerDataSource()
        authenticationDatasource = MockAuthenticationDataSource()
        navigator = MockRootCoordinator()
        sut = ServerListViewModel(serverDataSource: serverDataSource,
                                  authenticationDatasource: authenticationDatasource,
                                  navigator: navigator,
                                  dispatcher: MockDispatcher.shared)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        serverDataSource = nil
        authenticationDatasource = nil
        navigator = nil
        cancellables = Set<AnyCancellable>()
    }

    func testThatFetchSucceeds() async {
        serverDataSource.expectedResponse = [Server(name: "abc", distance: 2), Server(name: "zwx", distance: 1)]
        await sut.fetch()

        let expectedServerItems = [
            ServerListViewModel.ServerItem(name: "abc", distance: "2 km"),
            ServerListViewModel.ServerItem(name: "zwx", distance: "1 km")
        ]

        XCTAssertEqual(serverDataSource.fetchListCallCount, 1)
        XCTAssertEqual(serverDataSource.fetchListCalledWith, false)
        XCTAssertEqual(sut.serverItems.map(\.name), expectedServerItems.map(\.name))
        XCTAssertEqual(sut.serverItems.map(\.distance), expectedServerItems.map(\.distance))
    }

    func testThatFetchPresentsErrorWhenDataSourceFails() async {
        serverDataSource.expectedFailure = .persistence(.deleteFailed(reason: "mock reason!"))
        await sut.fetch()

        XCTAssertEqual(navigator.presentAlertCallCount, 1)
        XCTAssertEqual(navigator.presentAlertCalledWith!.message, "mock reason!")
        XCTAssertEqual(navigator.presentAlertCalledWith!.title, "Error")
    }

    func testThatRefreshSucceeds() async {
        serverDataSource.expectedResponse = [Server(name: "abc", distance: 2), Server(name: "zwx", distance: 1)]
        await sut.refresh()

        let expectedServerItems = [
            ServerListViewModel.ServerItem(name: "abc", distance: "2 km"),
            ServerListViewModel.ServerItem(name: "zwx", distance: "1 km")
        ]

        XCTAssertEqual(serverDataSource.fetchListCallCount, 1)
        XCTAssertEqual(serverDataSource.fetchListCalledWith, true)
        XCTAssertEqual(sut.serverItems.map(\.name), expectedServerItems.map(\.name))
        XCTAssertEqual(sut.serverItems.map(\.distance), expectedServerItems.map(\.distance))
    }

    func testThatRefreshPresentsErrorWhenDataSourceFails() async {
        serverDataSource.expectedFailure = .persistence(.deleteFailed(reason: "mock reason!"))
        await sut.refresh()

        XCTAssertEqual(navigator.presentAlertCallCount, 1)
        XCTAssertEqual(navigator.presentAlertCalledWith!.message, "mock reason!")
        XCTAssertEqual(navigator.presentAlertCalledWith!.title, "Error")
    }

    func testThatLogoutSucceeds() async {
        await sut.logout()

        XCTAssertEqual(authenticationDatasource.logoutCallCount, 1)
        XCTAssertEqual(navigator.loggedOutCallCount, 1)
    }

    func testThatLogoutPresentsErrorWhenDataSourceFails() async {
        authenticationDatasource.expectedFailure = .network(.unknown(description: "mock description"))
        await sut.logout()

        XCTAssertEqual(navigator.presentAlertCallCount, 1)
        XCTAssertEqual(navigator.presentAlertCalledWith!.message, "mock description")
        XCTAssertEqual(navigator.presentAlertCalledWith!.title, "Error")
    }

    func testThatSortPresentDialogWithOptions() async {
        serverDataSource.expectedResponse = [Server(name: "abc", distance: 2), Server(name: "zwx", distance: 1)]
        await sut.fetch()
        sut.sort()

        XCTAssertEqual(navigator.presentDialogCallCount, 1)
        let dialogItem = navigator.presentDialogCalledWith!

        XCTAssertNil(dialogItem.title)
        XCTAssertNil(dialogItem.message)

        let dialogActionItems = dialogItem.actionItems

        XCTAssertEqual(dialogActionItems[0].label, "By Distance")
        XCTAssertEqual(dialogActionItems[1].label, "Alphabetically")
    }

    func testThatSortByDistanceSucceeds() async {
        serverDataSource.expectedResponse = [Server(name: "abc", distance: 2), Server(name: "zwx", distance: 1)]
        await sut.fetch()
        sut.sort()

        let sortByDistanceAction = navigator.presentDialogCalledWith!.actionItems[0]

        sortByDistanceAction.action?()
        XCTAssertEqual(sut.serverItems.map(\.distance), ["1 km", "2 km"])
    }

    func testThatSortAlphabeticallySucceeds() async {
        serverDataSource.expectedResponse = [Server(name: "zhj", distance: 2),
                                             Server(name: "tyu", distance: 1),
                                             Server(name: "abc", distance: 4)]
        await sut.fetch()
        sut.sort()

        let sortAlphabeticallyAction = navigator.presentDialogCalledWith!.actionItems[1]

        sortAlphabeticallyAction.action?()
        XCTAssertEqual(sut.serverItems.map(\.name), ["abc", "tyu", "zhj"])
    }

    func testThatLoadingIsUpdatedProperly() async {
        let expectation = expectation(description: #function)
        sut.$loading
            .dropFirst()
            .collect(2)
            .sink { states in
                XCTAssertEqual(states, [true, false])
                expectation.fulfill()
            }.store(in: &cancellables)

        await sut.fetch()
        await waitForExpectations(timeout: 1)
    }
}
