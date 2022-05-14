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
    @Published var taskIsCompleted: Bool = false
    @Published var showDatePicker: Bool = false
    @Published var editTask: Task?
    @Published var showSmallTaskRows: Bool = false
    @Published var percentageOfTodayTasksComplete: Double = 0.0
    
    @Published var savedTasks: [Task] = []
    
    let colors: [String] = ["Yellow", "Green", "Blue", "Purple", "Red", "Orange"]
    let taskTypes: [String] = ["Basic", "Urgent", "Important"]
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "task_manager")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        
        fetchTasks()
        updatePercentageOfTodayTasksCompleted()
    }
    
    func fetchTasks() {
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            savedTasks = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }

    func addTask() {
        var task: Task!
        
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: container.viewContext)
        }
        
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        saveTask()
        updatePercentageOfTodayTasksCompleted()
    }
    
    func deleteTask(task: Task) {
        container.viewContext.delete(task)
        saveTask()
    }
    
    func saveTask() {
        do {
            try container.viewContext.save()
            updatePercentageOfTodayTasksCompleted()
            fetchTasks()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    func updateTask(task: Task) {
        var _ = task

        
        saveTask()
        updatePercentageOfTodayTasksCompleted()
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
    
    func updatePercentageOfTodayTasksCompleted() {
        var todayCount = 0
        var todayCountCompleted = 0
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        for i in 0..<savedTasks.count {
            if savedTasks[i].deadline! < tomorrow {
                if savedTasks[i].isCompleted {
                    todayCountCompleted += 1
                }
                
                todayCount += 1
            }
        }
        
        percentageOfTodayTasksComplete = Double(todayCountCompleted) / Double(todayCount) * 100
    }
    
    func calendarInformation() -> [DayInformation] {
        var daysArray: [DayInformation] = []
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let day = calendar.component(.weekday, from: today)

        var numberOfDaysAgoToZero = 0
        
        if day > 0 {
            numberOfDaysAgoToZero = abs(day - 1)
        }

        for index in 0..<7 {
            let tomorrow = calendar.date(byAdding: .day, value: index - numberOfDaysAgoToZero, to: today)!
            
            daysArray.append(
                DayInformation(
                    dayOfTheWeek: getCalendarDay(calendar.component(.weekday, from: tomorrow)),
                    dayOfTheMonth: calendar.component(.day, from: tomorrow),
                    date: tomorrow
                    )
            )
        }
        
        return daysArray
    }
    
    func getCalendarDay(_ dayOfTheWeek: Int) -> String {
        var dayString = "M"
        
        switch dayOfTheWeek {
        case 1:
            dayString = "S"
        case 2:
            dayString = "M"
        case 3:
            dayString = "T"
        case 4:
            dayString = "W"
        case 5:
            dayString = "T"
        case 6:
            dayString = "F"
        case 7:
            dayString = "S"
        default:
            dayString = "S"
        }
        
        return dayString
    }
}
