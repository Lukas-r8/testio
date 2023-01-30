//
//  ServerList.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import SwiftUI

struct ServerListView<ViewModel: ServerListViewModelInterface>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            listContent
        }
        .background { Color.lightGray }
        .navigationTitle("Testio.")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: filterButton, trailing: logoutButton)
        .task {
            await viewModel.fetch()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

private extension ServerListView {
    var listContent: some View {
        List {
            Section(content: {
                ForEach(viewModel.serverItems) { serverItem in
                    HStack {
                        Text(serverItem.name)
                        Spacer()
                        Text(serverItem.distance)
                    }
                }
            }, header: {
                HStack(alignment: .bottom) {
                    Text("SERVER")
                    Spacer()
                    Text("DISTANCE")
                }
            })
        }
        .listStyle(.plain)
    }

    var filterButton: some View {
        Button {
            viewModel.sort()
        } label: {
            Label(title: { Text("Filter") }, icon: { Image.arrowUpAndDown })
                .labelStyle(.titleAndIcon)
        }
    }

    var logoutButton: some View {
        Button {
            viewModel.logout()
        } label: {
            Label(title: { Image.logout }, icon: { Text("Log out") })
                .labelStyle(.titleAndIcon)
        }
    }
}

final class MockViewModel: ServerListViewModelInterface {
    var serverItems: [ServerListViewModel.ServerItem] = []

    var errorAlert: AlertingItem?

    var filterAlert: AlertingItem?


    func sort() {

    }

    func logout() {

    }

    var errorMessage: String?

    let serverList = [Server(name: "Server 1", distance: 1343),
                      Server(name: "Server 2", distance: 455),
                      Server(name: "Server 3", distance: 123),
                      Server(name: "Server 4", distance: 1983),
                      Server(name: "Server 5", distance: 28947),
                      Server(name: "Server 6", distance: 134),
                      Server(name: "Server 1", distance: 1343),
                      Server(name: "Server 2", distance: 455),
                      Server(name: "Server 3", distance: 123),
                      Server(name: "Server 4", distance: 1983),
                      Server(name: "Server 5", distance: 28947),
                      Server(name: "Server 6", distance: 134),
                      Server(name: "Server 1", distance: 1343),
                      Server(name: "Server 2", distance: 455),
                      Server(name: "Server 3", distance: 123),
                      Server(name: "Server 4", distance: 1983),
                      Server(name: "Server 5", distance: 28947),
                      Server(name: "Server 6", distance: 134),
                      Server(name: "Server 5", distance: 28947),
                      Server(name: "Server 6", distance: 134),
                      Server(name: "Server 1", distance: 1343),
                      Server(name: "Server 2", distance: 455),
                      Server(name: "Server 3", distance: 123),
                      Server(name: "Server 4", distance: 1983),
                      Server(name: "Server 5", distance: 28947),
                      Server(name: "Server 6", distance: 134)]

    func fetch() async { }
    func refresh() async { }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ServerListView(viewModel: MockViewModel())
        }
    }
}
