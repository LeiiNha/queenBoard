//
//  ValidationServiceTests.swift
//  ValidationServiceTests
//
//  Created by Erica Geraldes on 08/12/2025.
//

import XCTest
@testable import QueenBoard

final class ValidationServiceTests: XCTestCase {
    var sut: ValidationService!
    
    override func setUp() {
        super.setUp()
        sut = ValidationService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testIsPositionSafe_NoQueens_ReturnsTrue() {
        // Given
        let board = BoardState(size: 8)
        let position = Position(0, 0)
        
        // When
        let isSafe = sut.isPositionSafe(position, in: board)
        
        // Then
        XCTAssertTrue(isSafe)
    }
    
}
