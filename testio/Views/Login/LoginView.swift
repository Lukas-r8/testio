//
//  LoginView.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 15) {
            Image.logo
                .padding()

            makeTextField(text: $viewModel.username, icon: .person, placeholder: "Username")
                .textInputAutocapitalization(.never)
                .padding(.horizontal)

            makeTextField(text: $viewModel.password, icon: .lock, placeholder: "Password", secure: true)

                .padding(.horizontal)

            Button("Log in") {
                Task {
                    await viewModel.login()
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal)
            .disabled(!viewModel.isLoginActive)

        }
        .frame(maxHeight: .infinity)
        .background(alignment: .bottom, content: { Image.unsplash })
        .ignoresSafeArea()
    }
}

private extension LoginView {
    @ViewBuilder
    func makeTextField(text: Binding<String>, icon: Image, placeholder: String, secure: Bool = false) -> some View {
        HStack {
            icon
            if secure {
                SecureField(text: text, prompt: Text(placeholder), label: { EmptyView() })
            } else {
                TextField(text: text, prompt: Text(placeholder), label: { EmptyView() })
            }

        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .padding(5)
        .background(content: { Color.lightGray })
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: mockLoginViewModel)
    }
}

let mockLoginViewModel = LoginViewModel(authenticationDataSource: MockAuthenticationDataSource())

struct MockAuthenticationDataSource: AuthenticationDataSourcing {
    func authenticate(username: String, password: String) async throws {

    }
}
