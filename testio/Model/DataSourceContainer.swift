//
//  DataSourceContainer.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class DataSourceContainer {
    private weak var serverDataSource: ServerDataSource?
    private weak var authenticationDataSource: AuthenticationDataSource?

    init() {
        // datasource dependencies here
    }

    func getServerDataSource() -> ServerDataSource {
        guard let serverDataSource else {
            let dataSource = ServerDataSource()
            serverDataSource = dataSource
            return dataSource
        }
        return serverDataSource
    }

    func getAuthenticationDataSource() -> AuthenticationDataSource {
        guard let authenticationDataSource else {
            let dataSource = AuthenticationDataSource()
            authenticationDataSource = dataSource
            return dataSource
        }
        return authenticationDataSource
    }
}
