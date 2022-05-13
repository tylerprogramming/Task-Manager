//
//  NotificationManager.swift
//  task manager
//
//  Created by Tyler Reed on 5/13/22.
//

import SwiftUI
import UserNotifications
import CoreData

class NotificationManager: ObservableObject {
//    @ObservedObject var dailyTaskModel: DailyTaskViewModel
    @Published var calendarNotificationEnabled = false
    @Published var savedNotifications: [Notifications] = []
    @ObservedObject var dailyTaskModel = DailyTaskViewModel()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "task_manager")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        
//        self.dailyTaskModel = dailyTaskModel

        fetchNotifications()
        
        if savedNotifications.isEmpty {
            print("empty")
            var notification: Notifications

            notification = Notifications(context: container.viewContext)
            notification.calendarEnabled = false
            saveNotifications()
        } else {
            savedNotifications[0].calendarEnabled = calendarNotificationEnabled
            print(calendarNotificationEnabled)
            saveNotifications()
        }
    }
    
    func fetchNotifications() {
        let request = NSFetchRequest<Notifications>(entityName: "Notifications")
        
        do {
            savedNotifications = try container.viewContext.fetch(request)
            calendarNotificationEnabled = savedNotifications[0].calendarEnabled
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func saveNotifications() {
        do {
            savedNotifications[0].calendarEnabled = calendarNotificationEnabled
            try container.viewContext.save()
            fetchNotifications()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .alert, .sound]
        
        // it remembers the device
        UNUserNotificationCenter.current().requestAuthorization(options: options) { sucess, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("success")
            }
        }
    }
    
    func scheduleNotifications() {
        var totalCount = 0
        var percentage = 0.0
        var totalComplete = 0
        
        for index in 0..<dailyTaskModel.savedEntities.count {
            if dailyTaskModel.savedEntities[index].isCompleted {
                totalComplete += 1
            }
            
            totalCount += 1
        }

        percentage = (Double(totalComplete) / Double(totalCount)) * 100
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Tasks Complete: \(totalComplete) [\(percentage)%]"
        content.subtitle = getMessageNotificationBasedOnComplete()
        content.sound = .default
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(
            identifier: uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func getMessageNotificationBasedOnComplete() -> String {
        return "Good Job!"
    }
}
