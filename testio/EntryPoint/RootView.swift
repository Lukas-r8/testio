//
//  RootView.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 26.01.23.
//

import SwiftUI
import Combine

final class RootCoordinator: ObservableObject {
    @Published var isAuthenticated: Bool = false

    private let dataSourceContainer: DataSourceContainer
    private let authenticationDataSource: AuthenticationDataSourcing
    lazy var loginViewModel = LoginViewModel(authenticationDataSource: dataSourceContainer.getAuthenticationDataSource())
    lazy var serverListViewModel = ServerListViewModel(serverDataSource: dataSourceContainer.getServerDataSource())

    init(dataSourceContainer: DataSourceContainer) {
        self.authenticationDataSource = dataSourceContainer.getAuthenticationDataSource()
        self.dataSourceContainer = dataSourceContainer

        authenticationDataSource.authReponse
            .map { $0 != nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAuthenticated)
    }
}

struct RootView: View {
    @ObservedObject var coordinator: RootCoordinator

    var body: some View {
        if coordinator.isAuthenticated {
            NavigationStack {
                ServerListView(viewModel: coordinator.serverListViewModel)
            }
        } else {
            LoginView(viewModel: coordinator.loginViewModel)
        }
    }
}
