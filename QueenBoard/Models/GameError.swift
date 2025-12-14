//
//  GameError.swift
//  QueenBoard
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

enum GameError: Error, LocalizedError {
    case invalidPosition
    case positionOccupied
    case conflictDetected
    case boardFull

    var errorDescription: String? {
        switch self {
        case .invalidPosition:
            return "Invalid position on the board"
        case .positionOccupied:
            return "A queen is already placed here"
        case .conflictDetected:
            return "This queen would be under attack!"
        case .boardFull:
            return "Board is full"
        }
    }
}
