//
//  LineDepartureList.swift
//  Juostako WatchKit Extension
//
//  Created by Martin Richter on 08.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import Foundation

struct LineDepartureList {
    let directedLine: DirectedLine
    let departures: [Int]
}

extension LineDepartureList: Identifiable {
    var id: String { "\(directedLine.line) \(directedLine.direction)" }
}
