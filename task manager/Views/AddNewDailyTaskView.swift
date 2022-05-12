//
//  AddNewDailyTaskView.swift
//  task manager
//
//  Created by Tyler Reed on 5/9/22.
//

import SwiftUI
import CoreData

struct AddNewDailyTaskView: View {
    @EnvironmentObject var dailyTaskModel: DailyTaskViewModel
    @Environment(\.self) var environment
    
    @State private var inputDailyTask: String = ""
    
    @Namespace var animation
    
    var body: some View {
        VStack {
            Text("Add Daily Tasks")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        environment.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
            
            HStack {
                Text("Add Daily Task:")
                TextField("Add Item", text: $inputDailyTask)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button {
                dailyTaskModel.addTask(title: inputDailyTask)
                inputDailyTask = ""
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
                    .shadow(radius: 8, x: 4, y: 4)
            }
            
            VStack(alignment: .leading) {
                ForEach(dailyTaskModel.savedEntities) { dailyTask in
                    HStack {
                        Text("\(dailyTask.title ?? "")")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    
                        Button {
                            dailyTaskModel.deleteDailyTask(entity: dailyTask)
                        } label: {
                            Image(systemName: "trash")
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                    }
                }.id(UUID())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

//struct AddNewDailyTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewDailyTaskView(dailyTasks: FetchedResults<DailyTask>)
//    }
//}
