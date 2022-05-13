//
//  DailyTaskPopupView.swift
//  task manager
//
//  Created by Tyler Reed on 5/12/22.
//

import SwiftUI
import Foundation

struct DailyTaskPopupView: View {
    @EnvironmentObject var dailyTaskModel: DailyTaskViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    
    @GestureState var popupOffset = CGSize.zero
    
    var body: some View {
        ZStack {
            if dailyTaskModel.showPopup {
                Color.black
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dailyTaskModel.showPopup.toggle()
                    }
                
                VStack {
                    HStack(alignment: .center) {
                        Text("Daily Tasks")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                        
                        Button {
                            notificationManager.calendarNotificationEnabled.toggle()
                            
                            if notificationManager.calendarNotificationEnabled {
                                notificationManager.requestAuthorization()
                                notificationManager.scheduleNotifications()
                                notificationManager.saveNotifications()
                            } else {
                                notificationManager.cancelNotifications()
                                notificationManager.saveNotifications()
                            }
                        } label: {
                            Image(systemName: notificationManager.calendarNotificationEnabled ? "bell.fill" : "bell")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.yellow)
                        
                    ForEach(dailyTaskModel.savedEntities) { dailyTask in
                        Label(
                            title: { Text(dailyTask.showTask) },
                            icon: { dailyTask.completionStatusSymbol }
                        )
                        .onTapGesture {
                            dailyTask.isCompleted.toggle()

                            withAnimation(.easeInOut(duration: 0.75)) {
                                dailyTaskModel.saveDailyTask()
                            }
                        }
                        .font(.title2)
                    }
                    .id(UUID())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        dailyTaskModel.showPopup.toggle()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    }
                    .padding(.bottom)
                }
                .frame(height: 350)
                .background(.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(.top, 50)
                .padding(.horizontal, 25)
                .offset(dailyTaskModel.popupOffset)
                .gesture(
                    DragGesture(minimumDistance: 100)
                        .updating($popupOffset, body: { (value, popupOffset, transaction) in
                            dailyTaskModel.popupOffset = value.translation

                        })
                        .onEnded({ value in
                            dailyTaskModel.showPopup.toggle()
                            dailyTaskModel.popupOffset = CGSize.zero
                        }))
                
            }
            
        }
        .onAppear {
            print(notificationManager.calendarNotificationEnabled)
        }
        .animation(.default, value: dailyTaskModel.showPopup)
    }
}
