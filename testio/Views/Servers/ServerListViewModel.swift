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

    @Published var errorMessage: String?

    init(serverDataSource: ServerDataSourcing) {
        self.serverDataSource = serverDataSource
    }

    func fetch() async {
        do {
            let list = try await serverDataSource.fetchList(forceRefresh: false)
            await MainActor.run { self.serverList = list }
        } catch {
            await MainActor.run { self.errorMessage = error.localizedDescription }
        }
    }

    func refresh() async {
        do {
            self.serverList = try await serverDataSource.fetchList(forceRefresh: true)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
