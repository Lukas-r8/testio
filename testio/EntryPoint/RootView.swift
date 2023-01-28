//
//  RootView.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 26.01.23.
//

import SwiftUI

final class RootCoordinator: ObservableObject {
    @Published var isAuthenticated: Bool = false

    private let dataSourceContainer: DataSourceContainer
    lazy var loginViewModel = LoginViewModel(authenticationDataSource: dataSourceContainer.getAuthenticationDataSource())
    lazy var serverListViewModel = ServerListViewModel(serverDataSource: dataSourceContainer.getServerDataSource())

    init(dataSourceContainer: DataSourceContainer) {
        self.dataSourceContainer = dataSourceContainer
    }
}

struct RootView: View {
    let coordinator: RootCoordinator

    var body: some View {
        if coordinator.isAuthenticated {
            ServerListView(viewModel: coordinator.serverListViewModel)
        } else {
            LoginView(viewModel: coordinator.loginViewModel)
        }
    }
}
