//
//  GameEngineTests.swift
//  GameEngineTests
//
//  Created by Erica Geraldes on 08/12/2025.
//

import XCTest
@testable import QueenBoard

final class GameEngineTests: XCTestCase {
    var sut: GameEngine!

    override func setUp() {
        super.setUp()
        sut = GameEngine()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCreateGame_CreatesEmptyBoard() {
        // Given
        let config = GameConfiguration(boardSize: 8)

        // When
        let board = sut.createGame(with: config)

        // Then
        XCTAssertEqual(board.size, 8)
        XCTAssertEqual(board.queensCount, 0)
    }

    func testPlaceQueen_ValidPosition_Success() {
        // Given
        let board = BoardState(size: 8)
        let position = Position(0, 0)

        // When
        let result = sut.placeQueen(at: position, in: board)

        // Then
        switch result {
        case .success(let newBoard):
            XCTAssertEqual(newBoard.queensCount, 1)
            XCTAssertTrue(newBoard.hasQueen(at: position))
        case .failure:
            XCTFail("Expected success")
        }
    }

    func testPlaceQueen_OccupiedPosition_Failure() {
        // Given
        var board = BoardState(size: 8)
        let position = Position(0, 0)
        board.addQueen(Queen(position: position))

        // When
        let result = sut.placeQueen(at: position, in: board)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, .positionOccupied)
        }
    }

    func testPlaceQueen_InvalidPosition_Failure() {
        // Given
        let board = BoardState(size: 8)
        let position = Position(-1, 0)

        // When
        let result = sut.placeQueen(at: position, in: board)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, .invalidPosition)
        }
    }

    func testRemoveQueen_RemovesQueenSuccessfully() {
        // Given
        var board = BoardState(size: 8)
        let position = Position(0, 0)
        board.addQueen(Queen(position: position))

        // When
        let newBoard = sut.removeQueen(at: position, in: board)

        // Then
        XCTAssertEqual(newBoard.queensCount, 0)
        XCTAssertFalse(newBoard.hasQueen(at: position))
    }

    func testValidateSolution_ValidSolution_ReturnsTrue() {
        // Given
        var board = BoardState(size: 4)
        // Valid 4-queens solution
        board.addQueen(Queen(position: Position(0, 1)))
        board.addQueen(Queen(position: Position(1, 3)))
        board.addQueen(Queen(position: Position(2, 0)))
        board.addQueen(Queen(position: Position(3, 2)))

        // When
        let isValid = sut.validateSolution(board)

        // Then
        XCTAssertTrue(isValid)
    }

    func testValidateSolution_InvalidSolution_ReturnsFalse() {
        // Given
        var board = BoardState(size: 4)
        // Invalid solution - same column
        board.addQueen(Queen(position: Position(0, 0)))
        board.addQueen(Queen(position: Position(1, 0)))
        board.addQueen(Queen(position: Position(2, 1)))
        board.addQueen(Queen(position: Position(3, 2)))

        // When
        let isValid = sut.validateSolution(board)

        // Then
        XCTAssertFalse(isValid)
    }

    func testGetSafePositions_ReturnsCorrectPositions() {
        // Given
        var board = BoardState(size: 4)
        board.addQueen(Queen(position: Position(0, 0)))

        // When
        let safePositions = sut.getSafePositions(in: board)

        // Then
        XCTAssertFalse(safePositions.contains(Position(0, 1))) // Same row
        XCTAssertFalse(safePositions.contains(Position(1, 0))) // Same column
        XCTAssertFalse(safePositions.contains(Position(1, 1))) // Diagonal
        XCTAssertTrue(safePositions.contains(Position(1, 2))) // Safe
    }
}
