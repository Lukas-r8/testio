//
//  View+Presentation.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 28.01.23.
//

import SwiftUI

extension View {
    func navigate<Item>(_ item: Binding<Item?>, destination: (Item) -> some View) -> some View {
        let isPresented = Binding(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )
        return self.navigationDestination(isPresented: isPresented, destination: { item.wrappedValue.map(destination) })
    }

    func confirmationDialog(_ item: Binding<AlertingItem?>) -> some View {
        let shouldPresentAlert = Binding<Bool>(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        let alertingItem = item.wrappedValue

        return confirmationDialog(
            alertingItem?.title ?? "",
            isPresented: shouldPresentAlert,
            presenting: alertingItem,
            actions: { alertingItem in
                ForEach(alertingItem?.actionItems ?? []) { item in
                    Button(action: {
                        item.action?()
                    }, label: {
                        Text(item.label)
                    })
                }

            },
            message: { alertingItem in alertingItem?.message.map { Text($0) } }
        )
    }

    func alert(_ item: Binding<AlertingItem?>) -> some View {
        let shouldPresentAlert = Binding<Bool>(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        let alertingItem = item.wrappedValue

        return alert(
            alertingItem?.title ?? "",
            isPresented: shouldPresentAlert,
            presenting: alertingItem,
            actions: { alertingItem in
                ForEach(alertingItem?.actionItems ?? []) { item in
                    Button(action: {
                        item.action?()
                    }, label: {
                        Text(item.label)
                    })
                }
            },
            message: { alertingItem in alertingItem?.message.map { Text($0) } }
        )
    }
}

struct AlertingItem {
    struct ActionItem: Identifiable {
        typealias ActionHandler = () -> Void
        let id = UUID()
        let label: String
        let action: ActionHandler?

        init(label: String, action: ActionHandler? = nil) {
            self.label = label
            self.action = action
        }
    }
    let title: String?
    let message: String?
    let actionItems: [ActionItem]

    init(title: String? = nil, message: String? = nil, actionItems: ActionItem...) {
        self.title = title
        self.message = message
        self.actionItems = actionItems
    }
}
