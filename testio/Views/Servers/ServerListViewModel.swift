//
//  ServerListViewModel.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class ServerListViewModel: ObservableObject {
    private let serverDataSource: ServerDataSourcing

    @Published var serverList: [Server] = []

    init(serverDataSource: ServerDataSourcing) {
        self.serverDataSource = serverDataSource
    }

    func fetch() async {
        self.serverList = try! await serverDataSource.fetchList()
    }
}
