//
//  GameStatistics.swift
//  GameStatistics
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

struct GameStatistics: Codable {
    var gamesPlayed: Int = 0
    var gamesWon: Int = 0
    var bestTimes: [Int: TimeInterval] = [:]
    var totalMoves: Int = 0

    var winRate: Double {
        guard gamesPlayed > 0 else { return 0 }
        return Double(gamesWon) / Double(gamesPlayed) * 100
    }

    mutating func recordWin(boardSize: Int, time: TimeInterval, moves: Int) {
        gamesPlayed += 1
        gamesWon += 1
        totalMoves += moves

        if let currentBest = bestTimes[boardSize] {
            bestTimes[boardSize] = min(currentBest, time)
        } else {
            bestTimes[boardSize] = time
        }
    }

    mutating func recordGame() {
        gamesPlayed += 1
    }

    func bestTime(for boardSize: Int) -> TimeInterval? {
        bestTimes[boardSize]
    }
}
