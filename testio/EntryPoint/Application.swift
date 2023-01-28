//
//  Application.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class TokenRepository: Repository {
    func fetch<T>() throws -> T where T : Persistable {
        fatalError()
    }

    func save<T>(_ item: T) throws where T : Persistable {
        fatalError()
    }

    func delete<T>(_ item: T) throws where T : Persistable {
        fatalError()
    }

    func update<T>(_ transform: (T) -> Void) throws where T : Persistable {
        fatalError()
    }
}

final class Application {
    let dataSourceContainer: DataSourceContainer
    let rootCoordinator: RootCoordinator

    init() {
        let networkService = NetworkService(tokenRepository: TokenRepository())
        self.dataSourceContainer = DataSourceContainer(networkService: networkService)

        self.rootCoordinator = RootCoordinator(dataSourceContainer: self.dataSourceContainer)
    }
}
