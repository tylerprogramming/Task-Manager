//
//  ContentView.swift
//  task manager
//
//  Created by Tyler Reed on 5/6/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    
    var body: some View {
        NavigationView {
        Home()
            .navigationTitle("Task Manager")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        withAnimation(.easeInOut) {
                            taskModel.showSmallTaskRows.toggle()
                        }
                    } label: {
                        Text("Small Rows")
                    }
                }
            }
            .environmentObject(taskModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
