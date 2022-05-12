//
//  DailyTasks+Extension.swift
//  task manager
//
//  Created by Tyler Reed on 5/9/22.
//

import SwiftUI

extension DailyTask {
    var showTask: String {
        return title ?? "No Task."
    }

    enum CompletionStatus: String, CaseIterable, Identifiable {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case complete = "Complete"
        
        var id: String { self.rawValue }
    }

    var completionStatusSymbol: Image {
        switch self.isCompleted {
            case true : return Image(systemName: "checkmark.square")
            case false : return Image(systemName: "square")
        }
    }
}
