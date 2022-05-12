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
    
    var body: some View {
        Home()
            .environmentObject(taskModel)
            .environmentObject(dailyTaskModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
