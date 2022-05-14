//
//  ContentView.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var taskModel: TaskViewModel
    @ObservedObject var dailyTaskModel: DailyTaskViewModel
    @ObservedObject var notificationManager: NotificationManager
    
    var body: some View {
        Home(
            taskModel: taskModel,
            dailyTaskModel: dailyTaskModel,
            notificationManager: notificationManager
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(taskModel: TaskViewModel(), dailyTaskModel: DailyTaskViewModel(), notificationManager: NotificationManager())
    }
}
