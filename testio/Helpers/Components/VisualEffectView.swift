//
//  VisualEffectView.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import SwiftUI
import UIKit

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

extension UIVisualEffect {
    static let blurEffect = UIBlurEffect(style: .regular)
}
