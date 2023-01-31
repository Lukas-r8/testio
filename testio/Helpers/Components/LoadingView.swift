//
//  LoadingView.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import SwiftUI

struct LoadingView: View {
    let text: String?
    var body: some View {
        VStack(alignment: .center) {
            ProgressView()
                .padding(.top, 35)

            if let text {
                Spacer()
                Text(text)
                    .lineLimit(1)
                    .padding(.bottom)
                    .padding(.horizontal, 5)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 120, height: 120, alignment: .center)
        .background {
            Color.black
                .opacity(0.1)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: nil)
    }
}
