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
    lazy var serverListViewModel = ServerLis

    init(dataSourceContainer: DataSourceContainer) {
        self.dataSourceContainer = dataSourceContainer
    }
}

struct RootView: View {
    let coordinator: RootCoordinator

    var body: some View {
        if coordinator.isAuthenticated {
            ServerListView()
        } else {
            LoginView()
        }
    }
}
