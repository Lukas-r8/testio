//
//  Application.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import UIKit

final class Application {
    let dataSourceContainer: DataSourceContainer
    let rootCoordinator: RootCoordinator
    let keychain: Keychain = .default
    let coredataStack = CoreDataStack()

    init() {
        let authRepository = AuthRepository(keychain: keychain)
        let networkService = NetworkService(authRepository: authRepository)
        self.dataSourceContainer = DataSourceContainer(networkService: networkService, coredataStack: coredataStack, keychain: keychain)
        self.rootCoordinator = RootCoordinator(dataSourceContainer: self.dataSourceContainer)

        setUp()
    }
}

private extension Application {
    func setUp() {
    }
}
