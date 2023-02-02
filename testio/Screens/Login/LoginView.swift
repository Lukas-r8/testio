//
//  LoginView.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import SwiftUI

struct LoginView<ViewModel: LoginViewModelInterface>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            content
            if viewModel.loading {
                LoadingView(text: "Logging in")
            }
        }
        .frame(maxHeight: .infinity)
        .background(alignment: .bottom, content: { Image.unsplash })
        .ignoresSafeArea()
    }
}

private extension LoginView {
    var content: some View {
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
            .buttonStyle(PrimaryButtonStyle(disabled: !viewModel.isLoginActive))
            .padding(.horizontal)
            .disabled(!viewModel.isLoginActive)
        }
    }

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
