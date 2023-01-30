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
            LoginView(viewModel: coordinator.loginViewModel)
                .navigate($coordinator.serverListViewModel, destination: { serverListViewModel in
                    ServerListView(viewModel: serverListViewModel)
                        .navigationBarBackButtonHidden(true)
                })
        }
        .alert($coordinator.alert)
        .confirmationDialog($coordinator.dialog)
    }
}
