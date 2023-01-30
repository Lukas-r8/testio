//
//  RootCordinator.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 30.01.23.
//

import Foundation

final class RootCoordinator: ObservableObject {
    @Published var isAuthenticated: Bool = false

    private let container: DataSourceContainer
    private let authenticationDataSource: AuthenticationDataSourcing
    lazy var loginViewModel = LoginViewModel(authenticationDataSource: container.authenticationDataSource)
    lazy var serverListViewModel: ServerListViewModel = ServerListViewModel(serverDataSource: container.serverDataSource, authenticationDatasource: container.authenticationDataSource)

    init(dataSourceContainer: DataSourceContainer) {
        self.authenticationDataSource = dataSourceContainer.authenticationDataSource
        self.container = dataSourceContainer

        authenticationDataSource.authReponse
            .map { $0 != nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAuthenticated)
    }
}
