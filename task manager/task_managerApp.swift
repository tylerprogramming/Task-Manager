//
//  task_managerApp.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI

@main
struct task_managerApp: App {
    @StateObject var taskModel: TaskViewModel = .init()
    @StateObject var dailyTaskModel: DailyTaskViewModel = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskModel)
                .environmentObject(dailyTaskModel)
        }
    }
}
