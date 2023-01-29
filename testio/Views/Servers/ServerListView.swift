//
//  ServerList.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import SwiftUI

struct ServerListView: View {
    @ObservedObject var viewModel: ServerListViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Text("SERVER")
                Spacer()
                Text("DISTANCE")
            }
            .padding(.horizontal)
            .padding(.vertical, 5)

            List(viewModel.serverList, id: \.name) { server in
                HStack {
                    Text(server.name)
                    Spacer()
                    Text("\(server.distance)")
                }
            }
            .listStyle(.plain)
        }
        .background { Color.lightGray }
        .navigationTitle("Server List")
        .task {
            await viewModel.fetch()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

//struct MyPreviewProvider_Previews: PreviewProvider {
//    static var previews: some View {
//        ServerListView(viewModel: mockServerViewModel)
//    }
//}
//
//let mockServerViewModel = ServerListViewModel(serverDataSource: MockServerDataSource())
//
//struct MockServerDataSource: ServerDataSourcing {
//    func fetchList() async throws -> [Server] {
//        [Server(name: "Server 1", distance: 1343),
//         Server(name: "Server 2", distance: 455),
//         Server(name: "Server 3", distance: 123),
//         Server(name: "Server 4", distance: 1983),
//         Server(name: "Server 5", distance: 28947),
//         Server(name: "Server 6", distance: 134),
//         Server(name: "Server 1", distance: 1343),
//         Server(name: "Server 2", distance: 455),
//         Server(name: "Server 3", distance: 123),
//         Server(name: "Server 4", distance: 1983),
//         Server(name: "Server 5", distance: 28947),
//         Server(name: "Server 6", distance: 134),
//         Server(name: "Server 1", distance: 1343),
//         Server(name: "Server 2", distance: 455),
//         Server(name: "Server 3", distance: 123),
//         Server(name: "Server 4", distance: 1983),
//         Server(name: "Server 5", distance: 28947),
//         Server(name: "Server 6", distance: 134),
//         Server(name: "Server 5", distance: 28947),
//         Server(name: "Server 6", distance: 134),
//         Server(name: "Server 1", distance: 1343),
//         Server(name: "Server 2", distance: 455),
//         Server(name: "Server 3", distance: 123),
//         Server(name: "Server 4", distance: 1983),
//         Server(name: "Server 5", distance: 28947),
//         Server(name: "Server 6", distance: 134)]
//    }
//}
