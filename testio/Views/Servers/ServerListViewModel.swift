//
//  ServerListViewModel.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol ServerListViewModelInterface: AnyObject, ObservableObject {
    var serverItems: [ServerListViewModel.ServerItem] { get }
    var loading: Bool { get }
    func sort()
    func logout()
    func fetch() async
    func refresh() async
}

final class ServerListViewModel: ServerListViewModelInterface {
    struct ServerItem: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let distance: String
    }
    enum SortCriteria {
        case alphabetical
        case distance
    }

    private unowned let navigator: RootNavigator
    private let serverDataSource: ServerDataSourcing
    private let authenticationDatasource: AuthenticationDataSourcing
    private var sortCriteria: SortCriteria = .alphabetical

    @Published private var serverList: [Server] = []

    @Published var loading: Bool = false
    var serverItems: [ServerItem] { makeServerItem(from: serverList) }

    init(serverDataSource: ServerDataSourcing, authenticationDatasource: AuthenticationDataSourcing, navigator: RootNavigator) {
        self.serverDataSource = serverDataSource
        self.authenticationDatasource = authenticationDatasource
        self.navigator = navigator
    }

    func fetch() async {
        await load(forceRefresh: false)
    }

    func refresh() async {
        await load(forceRefresh: true)
    }

    func sort() {
        let byDistanceAction = AlertingItem.ActionItem(label: "By Distance", action: sortByDistance)
        let alphabeticallyAction = AlertingItem.ActionItem(label: "Alphabetically", action: sortByName)
        DispatchQueue.main.async {
            self.navigator.present(dialog: AlertingItem(actionItems: byDistanceAction, alphabeticallyAction))
        }
    }

    func logout() {
        Task { @MainActor in
            try await authenticationDatasource.logout()
            navigator.loggedOut()
        }
    }
}

private extension ServerListViewModel {
    func sortedFilterList(criteria: SortCriteria, list: [Server]) -> [Server] {
        switch criteria {
        case .alphabetical: return list.sorted { $0.name < $1.name }
        case .distance: return list.sorted { $0.distance < $1.distance }
        }
    }

    func load(forceRefresh: Bool) async {
        await MainActor.run { loading = true }
        do {
            let list = try await serverDataSource.fetchList(forceRefresh: forceRefresh)
            await MainActor.run {
                self.serverList = sortedFilterList(criteria: sortCriteria, list: list)
            }
        } catch {
            await MainActor.run { navigator.present(alert: AlertingItem(title: "Error", message: error.localizedDescription)) }
        }
        await MainActor.run { loading = false }
    }

    func makeServerItem(from serverList: [Server]) -> [ServerItem] {
        serverList.map { server in
            ServerItem(name: server.name, distance: "\(server.distance) km")
        }
    }

    func sortByDistance() {
        serverList.sort { $0.distance < $1.distance }
        sortCriteria = .distance
    }

    func sortByName() {
        serverList.sort { $0.name < $1.name }
        sortCriteria = .alphabetical
    }
}
