//
//  MarvelApp.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

@main
struct MarvelApp: App {
    let persistenceController = PersistenceController.shared

    init() {
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
