//
//  DataSourceContainer.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class DataSourceContainer {
    private let networkService: NetworkServicing

    private weak var serverDataSource: ServerDataSource<ServerRepository>?
    private weak var authenticationDataSource: AuthenticationDataSource<AuthRepository>?
    private let coredataStack: CoreDataStack
    private let keychain: Keychain

    init(networkService: NetworkServicing, coredataStack: CoreDataStack, keychain: Keychain) {
        self.networkService = networkService
        self.coredataStack = coredataStack
        self.keychain = keychain
    }

    func getServerDataSource() -> ServerDataSource<ServerRepository> {
        guard let serverDataSource else {
            let dataSource = ServerDataSource(networkServicing: networkService, serverRepository: ServerRepository(stack: coredataStack))
            serverDataSource = dataSource
            return dataSource
        }
        return serverDataSource
    }

    func getAuthenticationDataSource() -> AuthenticationDataSource<AuthRepository> {
        guard let authenticationDataSource else {
            let dataSource = AuthenticationDataSource(networkServicing: networkService, authRepository: AuthRepository(keychain: keychain))
            authenticationDataSource = dataSource
            return dataSource
        }
        return authenticationDataSource
    }
}
