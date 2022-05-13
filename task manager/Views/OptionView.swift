//
//  OptionView.swift
//  task manager
//
//  Created by Tyler Reed on 5/9/22.
//

import Foundation
import SwiftUI

struct OptionView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @EnvironmentObject var dailyTaskModel: DailyTaskViewModel
    
    @State private var showButtons = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                Button {
                    showButtons.toggle()
                    taskModel.openEditTask.toggle()
                } label: {
                    Image(systemName: "bag.badge.plus")
                        .padding(24)
                        .rotationEffect(Angle.degrees(showButtons ? 0 : -90))
                }
                .background(Circle().fill(Color.yellow).shadow(radius: 8, x: 4, y: 4))
                .opacity(showButtons ? 1 : 0)
                .offset(x: 0, y: showButtons ? -150 : 0)
                
                Button {
                    showButtons.toggle()
                    dailyTaskModel.openEditTask.toggle()
                } label: {
                    Image(systemName: "d.circle.fill")
                        .padding(24)
                        .rotationEffect(Angle.degrees(showButtons ? 0 : 90))
                }
                .background(Circle().fill(Color.blue).shadow(radius: 8, x: 4, y: 4))
                .offset(x: showButtons ? -110 : 0, y: showButtons ? -110 : 0)
                .opacity(showButtons ? 1 : 0)
                
                Button {
                    showButtons.toggle()
                    dailyTaskModel.showPopup.toggle()
                } label: {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .padding(24)
                        .rotationEffect(Angle.degrees(showButtons ? 0 : 90))
                }
                .background(Circle().fill(Color.red).shadow(radius: 8, x: 4, y: 4))
                .offset(x: showButtons ? -150 : 0, y: 0)
                .opacity(showButtons ? 1 : 0)
                
                Button {
                    showButtons.toggle()
                } label: {
                    Image(systemName: "plus")
                        .padding(24)
                        .rotationEffect(Angle.degrees(showButtons ? 45 : 0))
                }
                .background(Circle().fill(Color.green).shadow(radius: 8, x: 4, y: 4))
            }
            .padding(.trailing, 20)
            .accentColor(.white)
            .animation(.default, value: showButtons)
        }
        .font(.title)
    }
}
