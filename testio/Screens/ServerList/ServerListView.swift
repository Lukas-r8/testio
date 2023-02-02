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
        ZStack {
            listContent
            if viewModel.loading {
                LoadingView(text: "Loading list")
            }
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
        .animation(.linear, value: viewModel.serverItems)
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
            Task { @MainActor in
                await viewModel.logout()
            }
        } label: {
            Label(title: { Image.logout }, icon: { Text("Log out") })
                .labelStyle(.titleAndIcon)
        }
    }
}
