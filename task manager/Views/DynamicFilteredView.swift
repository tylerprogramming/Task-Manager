//
//  DynamicFilteredView.swift
//  task manager
//
//  Created by Tyler Reed on 5/7/22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    
    @State var currentTab: String
    @State var tasksArray: [Task]
    var filteredArray: [Task] = []
    
    init(currentTab: String, tasksArray: [Task]) {
        self.currentTab = currentTab
        self.tasksArray = tasksArray
        
        let calendar = Calendar.current
        
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            filteredArray = tasksArray.filter { task in
                return task.deadline! >= today && task.deadline! < tomorrow && !task.isCompleted
            }
        } else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            filteredArray = tasksArray.filter { task in
                return task.deadline! > tomorrow && !task.isCompleted
            }
        } else if currentTab == "Done" {
            filteredArray = tasksArray.filter { task in
                return task.isCompleted
            }
        } else {
            let today = calendar.startOfDay(for: Date())
            
            filteredArray = tasksArray.filter { task in
                return task.deadline! >= today && !task.isCompleted
            }
        }
        
        filteredArray = filteredArray.sorted {
            $0.deadline! < $1.deadline!
        }
    }
    
    var body: some View {
        Group {
            if filteredArray.isEmpty {
                Text("No tasks found!")
                    .font(.title2)
            } else {
                ForEach(filteredArray, id: \.self) { task in
                    TaskRowView(task: task)
                        .onTapGesture {
                            if !task.isCompleted {
                                taskModel.editTask = task
//                                taskModel.taskIsCompleted.toggle()
                                taskModel.openEditTask = true
                                taskModel.updateTask(task: task)
                                taskModel.setupTask()
                            }
                        }
                }
                .id(UUID())
            }
        }
    }
}
