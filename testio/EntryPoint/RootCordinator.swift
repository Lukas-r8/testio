//
//  RootCordinator.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 30.01.23.
//

import Foundation

protocol RootNavigator: AnyObject {
    func present(alert: AlertingItem)
    func present(dialog: AlertingItem)
    func loggedOut()
    func loggedIn()
}

final class RootCoordinator: ObservableObject {
    @Published var alert: AlertingItem?
    @Published var dialog: AlertingItem?

    private let container: DataSourceContainer
    private let authenticationDataSource: AuthenticationDataSourcing

    lazy var loginViewModel = LoginViewModel(authenticationDataSource: container.authenticationDataSource, navigator: self)
    var serverListViewModel: ServerListViewModel?

    init(dataSourceContainer: DataSourceContainer) {
        self.authenticationDataSource = dataSourceContainer.authenticationDataSource
        self.container = dataSourceContainer
    }
}

extension RootCoordinator: RootNavigator {
    func loggedOut() {
        self.serverListViewModel = nil
    }

    func loggedIn() {
        self.serverListViewModel = ServerListViewModel(serverDataSource: container.serverDataSource,
                                                       authenticationDatasource: container.authenticationDataSource,
                                                       navigator: self)
    }

    func present(alert: AlertingItem) {
        self.alert = alert
    }

    func present(dialog: AlertingItem) {
        self.dialog = dialog
    }
}
