//
//  StatisticsViewModel.swift
//  StatisticsViewModel
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation
import Combine

final class StatisticsViewModel: ObservableObject {
    @Published private(set) var statistics: GameStatistics
    @Published var selectedBoardSize: Int?
    @Published var showClearConfirmation = false

    private let persistenceService: PersistenceServiceProtocol

    var hasStatistics: Bool {
        statistics.gamesPlayed > 0
    }

    var sortedBestTimes: [(boardSize: Int, time: TimeInterval)] {
        statistics.bestTimes
            .map { (boardSize: $0.key, time: $0.value) }
            .sorted { $0.boardSize < $1.boardSize }
    }

    var averageMovesPerGame: Double {
        guard statistics.gamesPlayed > 0 else { return 0 }
        return Double(statistics.totalMoves) / Double(statistics.gamesPlayed)
    }

    init(persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.persistenceService = persistenceService
        self.statistics = persistenceService.loadStatistics()
    }

    func refresh() {
        statistics = persistenceService.loadStatistics()
    }

    func clearAllStatistics() {
        statistics = GameStatistics()
        persistenceService.saveStatistics(statistics)
    }

    func clearBestTime(for boardSize: Int) {
        statistics.bestTimes.removeValue(forKey: boardSize)
        persistenceService.saveStatistics(statistics)
    }

    func formattedTime(for timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func getBestTimeFormatted(for boardSize: Int) -> String? {
        guard let time = statistics.bestTime(for: boardSize) else { return nil }
        return formattedTime(for: time)
    }

    func getStatsSummary() -> StatsSummary {
        StatsSummary(
            totalGames: statistics.gamesPlayed,
            totalWins: statistics.gamesWon,
            winRate: statistics.winRate,
            totalMoves: statistics.totalMoves,
            averageMoves: averageMovesPerGame,
            bestTimesCount: statistics.bestTimes.count
        )
    }
}

struct StatsSummary {
    let totalGames: Int
    let totalWins: Int
    let winRate: Double
    let totalMoves: Int
    let averageMoves: Double
    let bestTimesCount: Int

    var formattedWinRate: String {
        String(format: "%.1f%%", winRate)
    }

    var formattedAverageMoves: String {
        String(format: "%.1f", averageMoves)
    }
}
