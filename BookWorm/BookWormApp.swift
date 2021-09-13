//
//  BookWormApp.swift
//  BookWorm
//
//  Created by Anthony Da cruz on 13/09/2021.
//

import SwiftUI

@main
struct BookWormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
