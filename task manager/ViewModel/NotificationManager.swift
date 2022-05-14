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
    @Published var calendarNotificationEnabled = false
    @Published var savedNotifications: [Notifications] = []
    
    @Published var total: Double = 0.0
    @Published var totalComplete: Double = 0.0
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "task_manager")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        
        fetchNotifications()
        
        if savedNotifications.isEmpty {
            var notification: Notifications

            notification = Notifications(context: container.viewContext)
            notification.calendarEnabled = false
            notification.totalDailyTasksComplete = 0.0
            notification.totalDailyTasks = 0.0
            
            do {
                try container.viewContext.save()
            } catch {
                print("\(error)")
            }
            
        } else {
            savedNotifications[0].calendarEnabled = calendarNotificationEnabled
            savedNotifications[0].totalDailyTasks = total
            
            saveNotifications()
        }
    }
    
    func fetchNotifications() {
        let request = NSFetchRequest<Notifications>(entityName: "Notifications")
        
        do {
            savedNotifications = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func saveNotifications() {
        do {
            // the first coredata element in Notifications is the calendar notification
            // may need to change later, used it this way to test since it's new to me
            savedNotifications[0].calendarEnabled = calendarNotificationEnabled
            savedNotifications[0].totalDailyTasks = total
            try container.viewContext.save()
            
            fetchNotifications()
            scheduleNotifications()
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
        let content = UNMutableNotificationContent()
        content.title = "Daily Tasks Complete: \(totalComplete) - \((totalComplete / total) * 100)"
        content.subtitle = getMessageNotificationBasedOnComplete()
        content.sound = .default
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour = 22
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(
            identifier: uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func getMessageNotificationBasedOnComplete() -> String {
        return "Good Job!"
    }
}
