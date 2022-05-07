//
//  Home.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var taskModel: TaskViewModel
    
    //MARK: Matched Geometry Namespace
    @Namespace var animation
    
    //MARK: Fetching Tasks
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)],
        predicate: nil,
        animation: .easeInOut)
    var tasks: FetchedResults<Task>
    
    @Environment(\.self) var environment
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here's Update Today.")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                TaskView()
                
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            Button {
                taskModel.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 22)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(
                    colors: [
                        .white.opacity(0.05),
                        .white.opacity(0.4),
                        .white.opacity(0.7),
                        .white
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        
        }
        .fullScreenCover(isPresented: $taskModel.openEditTask) {
            taskModel.resetTaskData()
        } content: {
            AddNewTask()
                .environmentObject(taskModel)
        }
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
    
    @ViewBuilder
    func TaskView() -> some View {
        LazyVStack(spacing: 12) {
            DynamicFilteredView(currentTab: taskModel.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
