//
//  DailyTaskViewModel.swift
//  task manager
//
//  Created by Tyler Reed on 5/9/22.
//

import SwiftUI
import CoreData

class DailyTaskViewModel: ObservableObject {
    @Published var showPopup: Bool = false
    @Published var popupOffset = CGSize.zero
    @Published var openEditTask: Bool = false
    @Published var editTask: DailyTask?
    @Published var percentageOfTasks: Double = 0
    @Published var savedEntities: [DailyTask] = []
    @Published var daysEntities: [Day] = []
//    @Published var currentDay: Int = 1
//    var currentMonth: Int = 12
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "task_manager")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)

        fetchDailyTasks()
        fetchDays()
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if daysEntities.isEmpty {
            addDayInformationToDayEntity()
        } else {
            // get the latest entry into Day as Int for Day of the Month
            let day = calendar.component(.day, from: daysEntities[daysEntities.count - 1].currentDate!)
            
            // get the current days Int for Day of the Month
            let currentDay = calendar.component(.day, from: today)
            
            // compare the days of the month
            if day != currentDay {
                resetDailyTasks()
                addDayInformationToDayEntity()
            }
        }
        
        // this gets the total tasks complete on the day
        // TODO: Make this retrieve from the actual day entity, or save from there to the Published property
        updatePercentageOfDailyTasksCompleted()
    }
    
    func addDayInformationToDayEntity() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var day: Day
        
        day = Day(context: container.viewContext)
        day.currentDate = today
        day.totalDailyTasksComplete = percentageOfTasks
        day.id = UUID()
        
        saveDailyTask()
    }
    
    func fetchDailyTasks() {
        let request = NSFetchRequest<DailyTask>(entityName: "DailyTask")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func fetchDays() {
        let request = NSFetchRequest<Day>(entityName: "Day")
        
        do {
            daysEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addTask(title: String) {
        //MARK: Updating Existing Data
        var dailyTask: DailyTask!
        
        if let editTask = editTask {
            dailyTask = editTask
        } else {
            dailyTask = DailyTask(context: container.viewContext)
        }
        
        dailyTask.title = title
        dailyTask.isCompleted = false
        dailyTask.id = UUID()
        
        saveDailyTask()
        updatePercentageOfDailyTasksCompleted()
    }
    
    func deleteDailyTask(entity: DailyTask) {
        container.viewContext.delete(entity)
        saveDailyTask()
    }
    
    func saveDailyTask() {
        do {
            try container.viewContext.save()
            
            fetchDailyTasks()
            fetchDays()
            updatePercentageOfDailyTasksCompleted()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    func resetDailyTasks() {
        for index in 0..<savedEntities.count {
            savedEntities[index].isCompleted = false
        }
        
        saveDailyTask()
    }
    
    func updatePercentageOfDailyTasksCompleted() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // if it's not the same day, don't update the task percentage
        // when it moves to the next day it will reset the tasks then come here and update yesterdays to zero
        // this check makes sure it won't do that on the next day
        if daysEntities[daysEntities.count - 1].currentDate == today {
            var count = 0
            
            for i in 0..<savedEntities.count {
                if savedEntities[i].isCompleted {
                    count += 1
                }
            }
            
            percentageOfTasks = Double(count) / Double(savedEntities.count) * 100
            daysEntities[daysEntities.count - 1].totalDailyTasksComplete = percentageOfTasks
            
            do {
                try container.viewContext.save()
            } catch {
                print("Couldn't save percentage of tasks for the current day. \(error)")
            }
        }
    }
    
    func checkDayPercentageOfTasks(dayInformation: DayInformation) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let dayOfTheMonth = dayInformation.dayOfTheMonth
        let currentDay = calendar.component(.day, from: today)
        
        if dayOfTheMonth == currentDay {
            return true
        }
        
        return false
    }
    
    func getOtherDaysPercentageOfTasks(dayInformation: DayInformation) -> Double {
        var percentageOfDailyTasksComplete = 0.0
        
        for index in 0..<daysEntities.count {
            if daysEntities[index].currentDate == dayInformation.date {
                percentageOfDailyTasksComplete = Double(daysEntities[index].totalDailyTasksComplete)
            }
        }
        
        return percentageOfDailyTasksComplete
    }
}
