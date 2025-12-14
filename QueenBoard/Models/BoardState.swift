//
//  BoardState.swift
//  BoardState
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

struct BoardState: Equatable {
    let size: Int
    var queens: [Queen]

    init(size: Int, queens: [Queen] = []) {
        self.size = size
        self.queens = queens
    }

    var queensCount: Int { queens.count }
    var remainingQueens: Int { size - queensCount }
    var isSolved: Bool { queensCount == size && !hasConflicts }

    var hasConflicts: Bool {
        for (index, queen) in queens.enumerated() {
            for otherQueen in queens.dropFirst(index + 1) {
                if queen.position.threatens(otherQueen.position) {
                    return true
                }
            }
        }
        return false
    }

    func allPositions() -> [Position] {
        var positions: [Position] = []
        for row in 0..<size {
            for col in 0..<size {
                positions.append(Position(row, col))
            }
        }
        return positions
    }

    func hasQueen(at position: Position) -> Bool {
        queens.contains { $0.position == position }
    }

    func queen(at position: Position) -> Queen? {
        queens.first { $0.position == position }
    }

    func threatenedPositions() -> Set<Position> {
        var threatened = Set<Position>()
        for queen in queens {
            for row in 0..<size {
                for col in 0..<size {
                    let pos = Position(row, col)
                    if queen.position.threatens(pos) && pos != queen.position {
                        threatened.insert(pos)
                    }
                }
            }
        }
        return threatened
    }

    func conflicts(for queen: Queen) -> [Queen] {
        queens.filter { otherQueen in
            otherQueen.id != queen.id &&
            queen.position.threatens(otherQueen.position)
        }
    }

    mutating func addQueen(_ queen: Queen) {
        queens.append(queen)
    }

    mutating func removeQueen(at position: Position) {
        queens.removeAll { $0.position == position }
    }
}

// Codable conformance for BoardState
extension BoardState: Codable {
    enum CodingKeys: String, CodingKey {
        case size, queens
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        size = try container.decode(Int.self, forKey: .size)
        queens = try container.decode([Queen].self, forKey: .queens)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(size, forKey: .size)
        try container.encode(queens, forKey: .queens)
    }
}
