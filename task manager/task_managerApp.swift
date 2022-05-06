//
//  task_managerApp.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI

@main
struct task_managerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
