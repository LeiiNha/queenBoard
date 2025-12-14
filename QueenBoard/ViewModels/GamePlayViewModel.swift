//
//  GamePlayViewModel.swift
//  GamePlayViewModel
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation
import Combine
import SwiftUI

protocol GamePlayViewModelProtocol: ObservableObject {
    // State exposed to the view
    var boardState: BoardState { get }
    var gameSession: GameSession { get }
    var isGameWon: Bool { get }
    var showVictory: Bool { get }
    var showHints: Bool { get set }
    var showStatistics: Bool { get set }
    var soundEnabled: Bool { get set }
    var errorMessage: String? { get }
    var currentTime: TimeInterval { get }

    // Derived UI values
    var queensPlaced: Int { get }
    var queensRemaining: Int { get }
    var moveCount: Int { get }
    var hasConflicts: Bool { get }
    var boardSize: Int { get }
    var formattedTime: String { get }
    var bestTime: String? { get }

    // Actions
    func toggleQueen(at position: Position)
    func placeQueen(at position: Position)
    func removeQueen(at position: Position)
    func resetGame()

    // Queries
    func getSafePositions() -> [Position]
    func isPositionThreatened(_ position: Position) -> Bool
    func getConflictingQueens(for position: Position) -> [Position]
    func isSafe(for position: Position) -> Bool
}

final class GamePlayViewModel: ObservableObject, GamePlayViewModelProtocol {

    @Published private(set) var boardState: BoardState
    @Published private(set) var gameSession: GameSession
    @Published private(set) var isGameWon = false
    @Published private(set) var showVictory = false
    @Published var showHints = false
    @Published var showStatistics = false
    @Published var soundEnabled = true
    @Published private(set) var errorMessage: String?
    @Published private(set) var currentTime: TimeInterval = 0

    private let gameEngine: GameEngineProtocol
    private let validationService: ValidationServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    private let audioService: AudioServiceProtocol
    private let configuration: GameConfiguration

    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    private var statistics: GameStatistics

    var queensPlaced: Int { boardState.queensCount }
    var queensRemaining: Int { boardState.remainingQueens }
    var moveCount: Int { gameSession.moves }
    var hasConflicts: Bool { boardState.hasConflicts }
    var boardSize: Int { boardState.size }

    var formattedTime: String {
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var bestTime: String? {
        guard let time = statistics.bestTime(for: boardSize) else { return nil }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init(
        configuration: GameConfiguration,
        gameEngine: GameEngineProtocol = GameEngine(),
        validationService: ValidationServiceProtocol = ValidationService(),
        persistenceService: PersistenceServiceProtocol = PersistenceService(),
        audioService: AudioServiceProtocol = AudioService()
    ) {
        self.configuration = configuration
        self.gameEngine = gameEngine
        self.validationService = validationService
        self.persistenceService = persistenceService
        self.audioService = audioService

        if let savedState = persistenceService.loadBoardState(for: configuration) {
            self.boardState = savedState
        } else {
            self.boardState = gameEngine.createGame(with: configuration)
        }

        self.gameSession = GameSession(boardSize: configuration.boardSize, startTime: Date())
        self.statistics = persistenceService.loadStatistics()

        setupObservers()
        startTimer()
    }

    private func setupObservers() {

        $boardState
            .sink { [weak self] state in
                self?.checkWinCondition(state)
                self?.saveBoardState(state)
            }
            .store(in: &cancellables)

        $soundEnabled
            .sink { [weak self] enabled in
                self?.audioService.setEnabled(enabled)
            }
            .store(in: &cancellables)
    }

    private func startTimer() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, !self.isGameWon else { return }
                self.currentTime = self.gameSession.duration
            }
    }

    func toggleQueen(at position: Position) {
        if boardState.hasQueen(at: position) {
            removeQueen(at: position)
        } else {
            placeQueen(at: position)
        }
    }

    func placeQueen(at position: Position) {
        let result = gameEngine.placeQueen(at: position, in: boardState)

        switch result {
        case .success(let newState):

            withAnimation(Constants.Animation.default) {
                boardState = newState
                gameSession.moves += 1
                errorMessage = nil
            }
            audioService.playPlacementSound()

            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()

        case .failure(let error):
            showError(error.localizedDescription)
            audioService.playErrorSound()

            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        }
    }

    func removeQueen(at position: Position) {
        withAnimation(Constants.Animation.default) {
            boardState = gameEngine.removeQueen(at: position, in: boardState)
            gameSession.moves += 1
            errorMessage = nil
        }
        audioService.playRemovalSound()

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    func resetGame() {
        withAnimation {
            boardState = gameEngine.createGame(with: configuration)
            gameSession = GameSession(boardSize: configuration.boardSize, startTime: Date())
            isGameWon = false
            showVictory = false
            errorMessage = nil
            currentTime = 0
        }
        persistenceService.clearSavedGame()
        startTimer()
    }

    func getSafePositions() -> [Position] {
        gameEngine.getSafePositions(in: boardState)
    }

    func isPositionThreatened(_ position: Position) -> Bool {
        boardState.threatenedPositions().contains(position)
    }

    func getConflictingQueens(for position: Position) -> [Position] {
        validationService.getConflicts(for: position, in: boardState)
    }

    func isSafe(for position: Position) ->Bool {
        showHints && !boardState.hasQueen(at: position) && getSafePositions().contains(position)
    }

    private func checkWinCondition(_ state: BoardState) {
        if gameEngine.validateSolution(state) && !isGameWon {
            isGameWon = true
            gameSession.endTime = Date()
            gameSession.isWon = true

            statistics.recordWin(
                boardSize: boardSize,
                time: gameSession.duration,
                moves: gameSession.moves
            )
            persistenceService.saveStatistics(statistics)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.showVictory = true
                self?.audioService.playVictorySound()

                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
        }
    }

    private func showError(_ message: String) {
        errorMessage = message

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            withAnimation {
                self?.errorMessage = nil
            }
        }
    }

    private func saveBoardState(_ state: BoardState) {
        persistenceService.saveBoardState(state, for: configuration)
    }
}
