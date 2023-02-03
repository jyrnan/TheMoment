//
//  TheMomentApp.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

@main
struct TheMomentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
