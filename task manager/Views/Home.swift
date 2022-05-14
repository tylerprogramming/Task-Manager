//
//  Home.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI

struct Home: View {
    @ObservedObject var taskModel: TaskViewModel
    @ObservedObject var dailyTaskModel: DailyTaskViewModel
    @ObservedObject var notificationManager: NotificationManager

    @State var percentageOfTasksComplete: Double = 0
    @State var percentageOfTasksComplete2: Double = 25
    @State var percentageOfTasksComplete3: Double = 50
    
    //MARK: Matched Geometry Namespace
    @Namespace var animation
    
    @Environment(\.self) var environment
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back")
                        .font(.callout)
                    
                    HStack {
                        Text("Here's Update Today.")
                            .font(.title2.bold())
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.easeInOut) {
                                taskModel.showSmallTaskRows.toggle()
                            }
                        } label: {
                            Image(systemName: taskModel.showSmallTaskRows ? "circle" : "circle.inset.filled")
                                .foregroundColor(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                HStack {
                    ForEach(taskModel.calendarInformation(), id: \.self) { day in
                        VStack {
                            Text("\(day.dayOfTheMonth)")
                                .fontWeight(.semibold)
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text("\(day.dayOfTheWeek)")
                                .fontWeight(.bold)
                                .font(.title2)
                            Ring(taskModel: taskModel, dailyTaskModel: dailyTaskModel, dayInformation: day)
                                .scaledToFit()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                DynamicFilteredView(taskModel: taskModel, currentTab: taskModel.currentTab, tasksArray: taskModel.savedTasks)
//                    .id(UUID())
            }
            .padding()
        }
        .blur(radius: dailyTaskModel.showPopup ? 2 : 0)
        .overlay(alignment: .bottomTrailing) {
            OptionView(taskModel: taskModel, dailyTaskModel: dailyTaskModel)
            DailyTaskPopupView(dailyTaskModel: dailyTaskModel, notificationManager: notificationManager)
        }
        .fullScreenCover(isPresented: $taskModel.openEditTask) {
            taskModel.resetTaskData()
        } content: {
            AddNewTask(taskModel: taskModel)
        }
        .fullScreenCover(isPresented: $dailyTaskModel.openEditTask) {
            print("daily task")
        } content: {
            AddNewDailyTaskView(dailyTaskModel: dailyTaskModel, notificationManager: notificationManager)
        }
//        .onAppear {
//            notificationManager.dailyTaskModel = dailyTaskModel
//        }
        
    }
    
    //MARK: Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar() -> some View {
        let tabs = ["All", "Today", "Upcoming", "Done"]
        
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(taskModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background {
                        if taskModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            taskModel.currentTab = tab
                        }
                    }
            }
        }
    }
}

struct Ring: View {
    @ObservedObject var taskModel: TaskViewModel
    @ObservedObject var dailyTaskModel: DailyTaskViewModel
    
    var dayInformation: DayInformation
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    RingView(
                        lineWidth: 5,
                        backgroundColor: .blue.opacity(0.2),
                        foregroundColor: .blue,
                        percentage: taskModel.percentageOfTodayTasksComplete
                    )
                    .frame(width: geometry.size.width * 0.3)
                    RingView(
                        lineWidth: 8,
                        backgroundColor: .yellow.opacity(0.2),
                        foregroundColor: .yellow,
                        percentage: taskModel.percentageOfTodayTasksComplete
                    )
                    .frame(width: geometry.size.width * 0.65)
                
                    RingView(
                        lineWidth: 8,
                        backgroundColor: .red.opacity(0.2),
                        foregroundColor: .red,
                        percentage: dailyTaskModel.checkDayPercentageOfTasks(dayInformation: dayInformation) ? dailyTaskModel.percentageOfTasks : dailyTaskModel.getOtherDaysPercentageOfTasks(dayInformation: dayInformation)
                    )
                    .frame(width: geometry.size.width)
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(taskModel: TaskViewModel(), dailyTaskModel: DailyTaskViewModel(), notificationManager: NotificationManager())
    }
}
