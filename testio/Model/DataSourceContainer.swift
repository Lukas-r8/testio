//
//  DataSourceContainer.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class DataSourceContainer {
    private let networkService: NetworkServicing

    private weak var serverDataSource: ServerDataSource?
    private weak var authenticationDataSource: AuthenticationDataSource?

    init(networkService: NetworkServicing) {
        self.networkService = networkService
    }

    func getServerDataSource() -> ServerDataSource {
        guard let serverDataSource else {
            let dataSource = ServerDataSource(networkServicing: networkService)
            serverDataSource = dataSource
            return dataSource
        }
        return serverDataSource
    }

    func getAuthenticationDataSource() -> AuthenticationDataSource {
        guard let authenticationDataSource else {
            let dataSource = AuthenticationDataSource(networkServicing: networkService)
            authenticationDataSource = dataSource
            return dataSource
        }
        return authenticationDataSource
    }
}
