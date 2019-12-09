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
    
    var directedLine: DirectedLine {
        DirectedLine(line: line, direction: direction)
    }
}

struct LineColors: Codable {
    let fg: String
    let bg: String
}

struct Line: Codable {
    let name: String
    let product: String
    let color: LineColors?
}

struct DirectedLine {
    let line: Line
    let direction: String
}

extension DirectedLine: Comparable {
    static func == (lhs: DirectedLine, rhs: DirectedLine) -> Bool {
        return lhs.line.name == rhs.line.name && lhs.direction == rhs.direction
    }

    static func < (lhs: DirectedLine, rhs: DirectedLine) -> Bool {
        if (lhs.line.product != rhs.line.product) {
            return lhs.line.product == "subway"
        } else if (lhs.line.name != rhs.line.name) {
            return lhs.line.name < rhs.line.name
        } else {
            return lhs.direction < rhs.direction
        }
    }
}

extension DirectedLine: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.line.name)
        hasher.combine(self.direction)
    }
}
