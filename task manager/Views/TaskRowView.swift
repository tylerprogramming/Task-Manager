//
//  TaskRowView.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI

struct TaskRowView: View {
    @ObservedObject var task: Task
    
    @EnvironmentObject var taskModel: TaskViewModel
    @Environment(\.self) var environment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if taskModel.showSmallTaskRows {
                smallRowView
            } else {
                HStack {
                    Text(task.type ?? "")
                        .font(.callout)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background {
                            Capsule()
                                .fill(.white.opacity(0.5))
                        }
                    
                    Spacer()
                    
                    if !task.isCompleted {
                        Button {
                            task.isCompleted.toggle()
                            
                            withAnimation(.easeInOut(duration: 0.5)) {
                                taskModel.saveTask()
                            }
                        } label: {
                            Circle()
                                .strokeBorder(.black, lineWidth: 1.5)
                                .frame(width: 25, height: 25)
                                .contentShape(Circle())
                        }
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.black)
                    }
                }
                
                Text(task.title ?? "")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                
                HStack(alignment: .bottom, spacing: 0) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label {
                            Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                        } icon: {
                            Image(systemName: "calendar")
                        }
                        
                        Label {
                            Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                        } icon: {
                            Image(systemName: "clock")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
    
    var smallRowView: some View {
        VStack {
            HStack {
                Text(task.title ?? "")
                    .font(.subheadline.bold())
                    .foregroundColor(.black)
                    .padding(.vertical, 2)
                
                Spacer()
                
                if !task.isCompleted {
                    Button {
                        task.isCompleted.toggle()
                        
                        withAnimation(.easeInOut(duration: 0.5)) {
                            taskModel.saveTask()
                        }
                    } label: {
                        Image(systemName: "circle")
                            .foregroundColor(.black)
                    }
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.black)
                }
            }

            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
