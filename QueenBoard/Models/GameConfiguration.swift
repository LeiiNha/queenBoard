//
//  GameConfiguration.swift
//  GameConfiguration
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

struct GameConfiguration: Codable {
    let boardSize: Int
    let difficulty: Difficulty

    enum Difficulty: String, Codable, CaseIterable {
        case beginner = "Beginner (4×4)"
        case easy = "Easy (6×6)"
        case medium = "Medium (8×8)"
        case hard = "Hard (10×10)"
        case expert = "Expert (12×12)"
        case custom = "Custom"

        var boardSize: Int {
            switch self {
            case .beginner: return 4
            case .easy: return 6
            case .medium: return 8
            case .hard: return 10
            case .expert: return 12
            case .custom: return 8
            }
        }

        var color: String {
            switch self {
            case .beginner: return "green"
            case .easy: return "blue"
            case .medium: return "orange"
            case .hard: return "red"
            case .expert: return "purple"
            case .custom: return "gray"
            }
        }
    }

    init(boardSize: Int, difficulty: Difficulty = .custom) {
        self.boardSize = max(Constants.Game.minimiumBoardNumber, boardSize)
        self.difficulty = difficulty
    }

    init(difficulty: Difficulty) {
        self.boardSize = difficulty.boardSize
        self.difficulty = difficulty
    }
}
