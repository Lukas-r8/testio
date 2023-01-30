//
//  ServerListViewModel.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol ServerListViewModelInterface: AnyObject, ObservableObject {
    var serverList: [Server] { get }
    var errorAlert: AlertingItem? { get set }
    var filterAlert: AlertingItem? { get set }

    func sort()
    func logout()
    func fetch() async
    func refresh() async
}

final class ServerListViewModel: ServerListViewModelInterface {
    private let serverDataSource: ServerDataSourcing

    enum SortCriteria {
        case alphabetical
        case distance
    }
    private var sortCriteria: SortCriteria = .alphabetical

    @Published var serverList: [Server] = []
    @Published var errorAlert: AlertingItem?
    @Published var filterAlert: AlertingItem?

    init(serverDataSource: ServerDataSourcing) {
        self.serverDataSource = serverDataSource
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
        filterAlert = AlertingItem(actionItems: byDistanceAction, alphabeticallyAction)
    }

    func logout() {
        print("Logging out")
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
        do {
            let list = try await serverDataSource.fetchList(forceRefresh: forceRefresh)
            await MainActor.run { self.serverList = sortedFilterList(criteria: sortCriteria, list: list)}
        } catch {
            await MainActor.run { self.errorAlert = AlertingItem(title: "Error", message: error.localizedDescription) }
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
