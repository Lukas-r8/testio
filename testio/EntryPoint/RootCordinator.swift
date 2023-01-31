//
//  RootCordinator.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 30.01.23.
//

import Foundation
import Combine

protocol RootNavigator: AnyObject {
    func present(alert: AlertingItem)
    func present(dialog: AlertingItem)
    func loggedOut()
    func loggedIn()
}

final class RootCoordinator: ObservableObject {
    private let container: DataSourceContainer
    private let authenticationDataSource: AuthenticationDataSourcing
    private var cancellable: AnyCancellable?
    @Published var alert: AlertingItem?
    @Published var dialog: AlertingItem?
    @Published var serverListViewModel: ServerListViewModel?
    lazy var loginViewModel = LoginViewModel(authenticationDataSource: container.authenticationDataSource, navigator: self)

    init(dataSourceContainer: DataSourceContainer) {
        self.authenticationDataSource = dataSourceContainer.authenticationDataSource
        self.container = dataSourceContainer

        cancellable = authenticationDataSource
            .authReponse
            .compactMap { $0 != nil ? () : nil }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.loggedIn()
            }
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
