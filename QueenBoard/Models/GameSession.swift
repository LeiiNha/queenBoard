//
//  GameSession.swift
//  QueenBoard
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

struct GameSession: Identifiable {
    let id = UUID()
    let boardSize: Int
    var moves: Int = 0
    var startTime: Date
    var endTime: Date?
    var isWon: Bool = false

    var duration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }

    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
