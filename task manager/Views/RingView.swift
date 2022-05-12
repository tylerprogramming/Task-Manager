//
//  RingView.swift
//  task manager
//
//  Created by Tyler Reed on 5/10/22.
//

import SwiftUI

struct RingView: View {
    let lineWidth: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    var percentage: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // background track ring
                RingShape()
                    .stroke(style: StrokeStyle(lineWidth: lineWidth))
                    .fill(backgroundColor)
                // overlay ring
                RingShape(percent: percentage)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .fill(foregroundColor)
            }
        }
        .padding(lineWidth / 2)
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(lineWidth: 50, backgroundColor: .black, foregroundColor: .red, percentage: 75)
    }
}
