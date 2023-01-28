//
//  ServerListViewModel.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class ServerListViewModel: ObservableObject {
    private let serverDataSource: ServerDataSource

    init(serverDataSource: ServerDataSource) {
        self.serverDataSource = serverDataSource
    }

    func fetch() async {
        try! await serverDataSource.fetchList()
    }
}
