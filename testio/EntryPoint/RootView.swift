//
//  RootView.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 26.01.23.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var coordinator: RootCoordinator

    var body: some View {
        NavigationStack {
            if coordinator.isAuthenticated {
                ServerListView(viewModel: coordinator.serverListViewModel)
            } else {
                LoginView(viewModel: coordinator.loginViewModel)
            }
        }
    }
}
