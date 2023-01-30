//
//  LoginViewModel.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class LoginViewModel: ObservableObject {
    private let authenticationDataSource: AuthenticationDataSourcing
    private unowned let navigator: RootNavigator

    @Published var username: String = ""
    @Published var password: String = ""

    var isLoginActive: Bool { !username.isEmpty && !password.isEmpty }

    init(authenticationDataSource: AuthenticationDataSourcing, navigator: RootNavigator) {
        self.authenticationDataSource = authenticationDataSource
        self.navigator = navigator
    }

    func login() async {
        do {
            try await authenticationDataSource.authenticate(username: username, password: password)
            navigator.loggedIn()
        } catch {
            await MainActor.run {
                navigator.present(alert: AlertingItem(title: "Verification Failed", message: error.localizedDescription))
            }
        }
    }
}
