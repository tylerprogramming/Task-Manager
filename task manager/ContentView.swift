//
//  ContentView.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @EnvironmentObject var dailyTaskModel: DailyTaskViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        Home()
            .environmentObject(taskModel)
            .environmentObject(dailyTaskModel)
            .environmentObject(notificationManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
