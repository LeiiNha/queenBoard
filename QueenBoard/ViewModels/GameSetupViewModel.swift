//
//  GameSetupViewModel.swift
//  GameSetupViewModel
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation
import Combine

final class GameSetupViewModel: ObservableObject {
    @Published var selectedDifficulty: GameConfiguration.Difficulty = .medium
    @Published var customBoardSize: Int = 8
    @Published var showCustomSizeInput = false

    private let persistenceService: PersistenceServiceProtocol
    private(set) var statistics: GameStatistics

    init(persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.persistenceService = persistenceService
        self.statistics = persistenceService.loadStatistics()
    }

    func createConfiguration() -> GameConfiguration {
        if selectedDifficulty == .custom {
            return GameConfiguration(boardSize: customBoardSize, difficulty: .custom)
        } else {
            return GameConfiguration(difficulty: selectedDifficulty)
        }
    }

    func getBestTime(for difficulty: GameConfiguration.Difficulty) -> String? {
        guard let time = statistics.bestTime(for: difficulty.boardSize) else {
            return nil
        }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
