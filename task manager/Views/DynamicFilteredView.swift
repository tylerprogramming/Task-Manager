//
//  DynamicFilteredView.swift
//  task manager
//
//  Created by Tyler Reed on 5/7/22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    init(currentTab: String, @ViewBuilder content: @escaping (T)->Content) {
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else  if currentTab == "Done" {
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        } else {
            
        }
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No tasks found!")
                    .font(.title2)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
