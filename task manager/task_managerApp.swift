//
//  task_managerApp.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI
import UserNotifications

@main
struct task_managerApp: App {
    @StateObject var taskModel: TaskViewModel = .init()
    @StateObject var dailyTaskModel: DailyTaskViewModel = .init()
    @StateObject var notificationManager: NotificationManager = .init()

    var body: some Scene {
//        notificationManager = NotificationManager(dailyTaskModel: dailyTaskModel)
//        notificationManager = NotificationManager(dailyTaskModel: dailyTaskModel)
        
        WindowGroup {
            ContentView()
                .environmentObject(taskModel)
                .environmentObject(dailyTaskModel)
                .environmentObject(notificationManager)
                .onAppear {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
        }
    }
}
