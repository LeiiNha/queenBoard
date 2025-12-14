//
//  ValidationService.swift
//  ValidationService
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

protocol ValidationServiceProtocol {
    func isPositionSafe(_ position: Position, in boardState: BoardState) -> Bool
    func getConflicts(for position: Position, in boardState: BoardState) -> [Position]
    func validateMove(_ position: Position, in boardState: BoardState) -> ValidationResult
}

enum ValidationResult {
    case valid
    case warning(message: String)
    case invalid(message: String)

    var isValid: Bool {
        if case .valid = self { return true }
        return false
    }
}

final class ValidationService: ValidationServiceProtocol {

    func isPositionSafe(_ position: Position, in boardState: BoardState) -> Bool {
        let threatened = boardState.threatenedPositions()
        return !threatened.contains(position)
    }

    func getConflicts(for position: Position, in boardState: BoardState) -> [Position] {
        var conflicts: [Position] = []

        for queen in boardState.queens {
            if queen.position.threatens(position) {
                conflicts.append(queen.position)
            }
        }

        return conflicts
    }

    func validateMove(_ position: Position, in boardState: BoardState) -> ValidationResult {

        if boardState.hasQueen(at: position) {
            return .invalid(message: "Position already occupied")
        }

        let conflicts = getConflicts(for: position, in: boardState)
        if !conflicts.isEmpty {
            return .invalid(message: "Queen would be under attack from \(conflicts.count) queen(s)")
        }

        return .valid
    }
}
