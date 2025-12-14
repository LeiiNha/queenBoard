//
//  PersistenceService.swift
//  PersistenceService
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

protocol PersistenceServiceProtocol {
    func saveStatistics(_ statistics: GameStatistics)
    func loadStatistics() -> GameStatistics
    func saveBoardState(_ boardState: BoardState, for configuration: GameConfiguration)
    func loadBoardState(for configuration: GameConfiguration) -> BoardState?
    func clearSavedGame()
}

final class PersistenceService: PersistenceServiceProtocol {
    private let userDefaults = UserDefaults.standard

    private enum Keys {
        static let statistics = "game_statistics"
        static let savedBoardState = "saved_board_state"
        static let savedConfiguration = "saved_configuration"
    }

    func saveStatistics(_ statistics: GameStatistics) {
        if let encoded = try? JSONEncoder().encode(statistics) {
            userDefaults.set(encoded, forKey: Keys.statistics)
        }
    }

    func loadStatistics() -> GameStatistics {
        guard let data = userDefaults.data(forKey: Keys.statistics),
              let statistics = try? JSONDecoder().decode(GameStatistics.self, from: data) else {
            return GameStatistics()
        }
        return statistics
    }

    func saveBoardState(_ boardState: BoardState, for configuration: GameConfiguration) {
        let saveData = SavedGame(boardState: boardState, configuration: configuration)
        if let encoded = try? JSONEncoder().encode(saveData) {
            userDefaults.set(encoded, forKey: Keys.savedBoardState)
        }
    }

    func loadBoardState(for configuration: GameConfiguration) -> BoardState? {
        guard let data = userDefaults.data(forKey: Keys.savedBoardState),
              let savedGame = try? JSONDecoder().decode(SavedGame.self, from: data),
              savedGame.configuration.boardSize == configuration.boardSize else {
            return nil
        }
        return savedGame.boardState
    }

    func clearSavedGame() {
        userDefaults.removeObject(forKey: Keys.savedBoardState)
    }

    private struct SavedGame: Codable {
        let boardState: BoardState
        let configuration: GameConfiguration
    }
}
