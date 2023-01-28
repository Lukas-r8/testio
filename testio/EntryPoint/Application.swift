//
//  Application.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class Application {
    let dataSourceContainer: DataSourceContainer

    init(networkService: NetworkService) {
        dataSourceContainer = DataSourceContainer(networkService: networkService)
    }
}
