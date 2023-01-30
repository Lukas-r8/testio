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
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Text("SERVER")
                Spacer()
                Text("DISTANCE")
            }
            .padding(.horizontal)
            .padding(.vertical, 5)

            List(viewModel.serverList, id: \.name) { (server: Server) in
                HStack {
                    Text(server.name)
                    Spacer()
                    Text("\(server.distance)")
                }
            }
            .listStyle(.plain)
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
        .confirmationDialog($viewModel.filterAlert)
        .alert($viewModel.errorAlert)
    }
}

private extension ServerListView {
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
