//
//  NotificationView.swift
//  task manager
//
//  Created by Tyler Reed on 5/13/22.
//

import SwiftUI

struct NotificationView: View {
    @ObservedObject var notificationManager: NotificationManager
    @ObservedObject var dailyTaskModel: DailyTaskViewModel
    
    var body: some View {
        ZStack {
            Button {
                notificationManager.calendarNotificationEnabled.toggle()
                notificationManager.total = Double(dailyTaskModel.savedEntities.count)
                
                if notificationManager.calendarNotificationEnabled {
                    notificationManager.requestAuthorization()
                    notificationManager.scheduleNotifications()
                    notificationManager.saveNotifications()
                } else {
                    notificationManager.cancelNotifications()
                    notificationManager.saveNotifications()
                }
            } label: {
                Image(systemName: notificationManager.savedNotifications[0].calendarEnabled ? "bell.fill" : "bell")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .shadow(radius: 4)
            }
        }
    }
}
