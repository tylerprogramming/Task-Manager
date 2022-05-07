//
//  TaskViewModel.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    //MARK: New Task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    @Published var editTask: Task?
    @Published var showSmallTaskRows: Bool = false

    func addTask(context: NSManagedObjectContext) -> Bool {
        //MARK: Updating Existing Data
        var task: Task!
        
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        
        return false
    }
    
    func resetTaskData() {
        taskType = "Basic"
        taskColor = "Yellow"
        taskDeadline = Date()
        taskTitle = ""
    }
    
    func setupTask() {
        if let editTask = editTask {
            taskType = editTask.type ?? "Basic"
            taskColor = editTask.color ?? "Yellow"
            taskDeadline = editTask.deadline ?? Date()
            taskTitle = editTask.title ?? ""
        }
    }
}
