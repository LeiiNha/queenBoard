//
//  GameEngine.swift
//  GameEngine
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

protocol GameEngineProtocol {
    func createGame(with configuration: GameConfiguration) -> BoardState
    func placeQueen(at position: Position, in boardState: BoardState) -> Result<BoardState, GameError>
    func removeQueen(at position: Position, in boardState: BoardState) -> BoardState
    func validateSolution(_ boardState: BoardState) -> Bool
    func getSafePositions(in boardState: BoardState) -> [Position]
}

final class GameEngine: GameEngineProtocol {

    func createGame(with configuration: GameConfiguration) -> BoardState {
        return BoardState(size: configuration.boardSize)
    }

    func placeQueen(at position: Position, in boardState: BoardState) -> Result<BoardState, GameError> {

        guard position.row >= 0 && position.row < boardState.size &&
              position.column >= 0 && position.column < boardState.size else {
            return .failure(.invalidPosition)
        }

        guard !boardState.hasQueen(at: position) else {
            return .failure(.positionOccupied)
        }

        guard boardState.queensCount < boardState.size else {
            return .failure(.boardFull)
        }

        var newState = boardState
        let newQueen = Queen(position: position)
        newState.addQueen(newQueen)

        return .success(newState)
    }

    func removeQueen(at position: Position, in boardState: BoardState) -> BoardState {
        var newState = boardState
        newState.removeQueen(at: position)
        return newState
    }

    func validateSolution(_ boardState: BoardState) -> Bool {
        // Check queens count with N
        guard boardState.queensCount == boardState.size else {
            return false
        }

        return !boardState.hasConflicts
    }
    

    func getSafePositions(in boardState: BoardState) -> [Position] {

        let threatened = boardState.threatenedPositions()

        return boardState.allPositions().filter { position in
            !boardState.hasQueen(at: position) && !threatened.contains(position)
        }
    }
}
