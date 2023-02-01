//
//  LoginViewModel.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol LoginViewModelInterface: AnyObject, ObservableObject {
    var username: String { get set }
    var password: String { get set }
    var loading: Bool { get }
    var isLoginActive: Bool { get }

    func login() async
}

final class LoginViewModel: LoginViewModelInterface {
    private let authenticationDataSource: AuthenticationDataSourcing
    private unowned let navigator: RootNavigator

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var loading = false

    var isLoginActive: Bool { !username.isEmpty && !password.isEmpty }

    init(authenticationDataSource: AuthenticationDataSourcing, navigator: RootNavigator) {
        self.authenticationDataSource = authenticationDataSource
        self.navigator = navigator
    }

    func login() async {
        await MainActor.run { loading = true }
        do {
            try await authenticationDataSource.authenticate(username: username, password: password)
            await MainActor.run { navigator.loggedIn() }
        } catch {
            await MainActor.run { navigator.present(alert: AlertingItem(title: "Verification Failed", message: error.localizedDescription)) }
        }
        await MainActor.run { loading = false }
    }
}
