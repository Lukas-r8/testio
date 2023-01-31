//
//  Button+Styles.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 28.01.23.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let disabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(content: { Color.blue })
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(disabled ? 0.8 : 1)
    }
}
