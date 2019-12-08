//
//  SwiftUIView.swift
//  Juostako WatchKit Extension
//
//  Created by Martin Richter on 08.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import SwiftUI

struct MinutesBox: View {
    let minutes: Int
    
    var body: some View {
        Text("\(minutes)′")
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(fillColor(minutes: minutes))
            )
    }
    
    func fillColor(minutes: Int) -> Color {
        switch minutes {
        case ...(-1):
            return Color.red
        case 0:
            return Color.orange
        default:
            return Color.green
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MinutesBox(minutes: 1).previewDisplayName("Upcoming")
            MinutesBox(minutes: 0).previewDisplayName("Departing")
            MinutesBox(minutes: -1).previewDisplayName("Departed")
        }
    }
}
