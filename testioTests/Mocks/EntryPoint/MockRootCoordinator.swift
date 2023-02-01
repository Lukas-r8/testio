//
//  MockRootCoordinator.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

@testable import testio

final class MockRootCoordinator: RootNavigator {
    private(set) var presentAlertCallCount = 0
    private(set) var presentAlertCalledWith: AlertingItem?

    private(set) var presentDialogCallCount = 0
    private(set) var presentDialogCalledWith: AlertingItem?

    private(set) var loggedOutCallCount = 0
    private(set) var loggedInCallCount = 0

    func present(alert: AlertingItem) {
        presentAlertCallCount += 1
        presentAlertCalledWith = alert
    }

    func present(dialog: AlertingItem) {
        presentDialogCallCount += 1
        presentDialogCalledWith = dialog
    }

    func loggedOut() {
        loggedOutCallCount += 1
    }

    func loggedIn() {
        loggedInCallCount += 1
    }
}
