//
//  LoginViewModel.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class LoginViewModel: ObservableObject {
    private let authenticationDataSource: AuthenticationDataSource

    @Published var username: String = ""
    @Published var password: String = ""

    @Published var errorMessage: String?

    init(authenticationDataSource: AuthenticationDataSource) {
        self.authenticationDataSource = authenticationDataSource
    }

    func login() async {
        do {
            try await authenticationDataSource.authenticate(username: username, password: password)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
