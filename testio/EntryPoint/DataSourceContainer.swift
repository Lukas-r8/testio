//
//  DataSourceContainer.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class DataSourceContainer {
    private let networkService: NetworkServicing

    private weak var _serverDataSource: ServerDataSource<ServerRepository>?
    private weak var _authenticationDataSource: AuthenticationDataSource<AuthRepository>?
    private let coredataStack: CoreDataStack
    private let keychain: Keychain

    var serverDataSource: ServerDataSource<ServerRepository> {
        guard let serverDataSource = _serverDataSource else {
            let dataSource = ServerDataSource(networkServicing: networkService,
                                              serverRepository: ServerRepository(stack: coredataStack))
            _serverDataSource = dataSource
            return dataSource
        }
        return serverDataSource
    }

    var authenticationDataSource: AuthenticationDataSource<AuthRepository> {
        guard let authenticationDataSource = _authenticationDataSource else {
            let clearDataBase: AuthenticationDataSource.ClearDatabaseHandler = { [weak self] in
                try await self?.coredataStack.clear()
                self?.keychain.wipe()
            }
            let dataSource = AuthenticationDataSource(networkServicing: networkService,
                                                      authRepository: AuthRepository(keychain: keychain),
                                                      clearDatabase: clearDataBase)
            _authenticationDataSource = dataSource
            return dataSource
        }
        return authenticationDataSource
    }

    init(networkService: NetworkServicing, coredataStack: CoreDataStack, keychain: Keychain) {
        self.networkService = networkService
        self.coredataStack = coredataStack
        self.keychain = keychain
    }
}
