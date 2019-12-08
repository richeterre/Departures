//
//  Departure.swift
//  Juostako WatchKit Extension
//
//  Created by Martin Richter on 08.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import Foundation

struct Departure: Codable {
    let direction: String
    let when: Date
    let line: Line
}

struct Line: Codable {
    let name: String
}
