//
//  LoginViewModel.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class LoginViewModel: ObservableObject {
    private let authenticationDataSource: AuthenticationDataSourcing

    @Published var username: String = ""
    @Published var password: String = ""

    var isLoginActive: Bool { !username.isEmpty && !password.isEmpty }

    @Published var errorMessage: String?

    init(authenticationDataSource: AuthenticationDataSourcing) {
        self.authenticationDataSource = authenticationDataSource
    }

    func login() async {
        do {
            try await authenticationDataSource.authenticate(username: username, password: password)
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
