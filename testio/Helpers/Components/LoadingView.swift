//
//  LoadingView.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import SwiftUI

struct LoadingView: View {
    private enum Constants {
        static let size: CGFloat = 140
    }

    let text: String?

    init(text: String? = nil) {
        self.text = text
    }

    var body: some View {
        VStack(alignment: .center) {
            if let text {
                loadingWithText(text)
            } else {
                ProgressView()
            }
        }
        .frame(width: Constants.size, height: Constants.size, alignment: .center)
        .background {
            VisualEffectView(effect: .blurEffect)
                .opacity(0.8)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

private extension LoadingView {
    @ViewBuilder
    func loadingWithText(_ text: String) -> some View {
        ProgressView()
            .padding(.vertical)
        Text(text)
            .lineLimit(1)
            .foregroundColor(.darkGray)
    }
}
