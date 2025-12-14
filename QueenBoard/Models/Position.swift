//
//  Position.swift
//  QueenBoard
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

struct Position: Equatable, Codable, Hashable {
    let row: Int
    let column: Int

    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }

    func threatens(_ other: Position) -> Bool {
        if row == other.row { return true }
        if column == other.column { return true }
        if abs(row - other.row) == abs(column - other.column) { return true }

        return false
    }
}
