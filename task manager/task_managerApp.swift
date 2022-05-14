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
    @StateObject var taskModel = TaskViewModel()
    @StateObject var dailyTaskModel = DailyTaskViewModel()
    @StateObject var notificationManager = NotificationManager()

    var body: some Scene {

        WindowGroup {
            ContentView(taskModel: taskModel, dailyTaskModel: dailyTaskModel, notificationManager: notificationManager)
                .onAppear {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    notificationManager.requestAuthorization()
                }
        }
    }
}
