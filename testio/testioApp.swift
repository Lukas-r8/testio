//
//  testioApp.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 26.01.23.
//

import SwiftUI

@main
struct testioApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
