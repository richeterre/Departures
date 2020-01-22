//
//  Color.swift
//  Departures WatchKit Extension
//
//  Created by Martin Richter on 09.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hex = hex
        
        if (hex.hasPrefix("#")) {
            hex.remove(at: hex.startIndex)
        }
        if (hex.count == 3) {
            hex = hex + hex
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
