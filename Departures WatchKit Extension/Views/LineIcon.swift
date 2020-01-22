//
//  LineIcon.swift
//  Departures WatchKit Extension
//
//  Created by Martin Richter on 09.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import SwiftUI

struct LineIcon: View {
    let line: Line
    
    var body: some View {
        Text(line.name)
            .font(.system(size: 18, weight: .bold, design: .default))
            .foregroundColor(textColor(line.color))
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(backgroundColor(line.color))
            )
    }
    
    func textColor(_ lineColors: LineColors?) -> Color {
        if let lineColors = lineColors {
            return Color(hex: lineColors.fg)
        }
        return Color.white
    }
    
    func backgroundColor(_ lineColors: LineColors?) -> Color {
        if let lineColors = lineColors {
            return Color(hex: lineColors.bg)
        }
        return Color.gray
    }
}

struct LineIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineIcon(
                line: Line(
                    name: "U1",
                    product: "subway",
                    color: LineColors(fg: "#fff", bg: "55a822")
                )
            )
            LineIcon(
                line: Line(
                    name: "U7",
                    product: "subway",
                    color: LineColors(fg: "#fff", bg: "#3690c0")
                )
            )
        }
    }
}
