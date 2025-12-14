//
//  Queen.swift
//  Queen
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation

struct Queen: Identifiable, Equatable, Codable {
    let id: UUID
    var position: Position

    init(id: UUID = UUID(), position: Position) {
        self.id = id
        self.position = position
    }

    static func == (lhs: Queen, rhs: Queen) -> Bool {
        lhs.id == rhs.id
    }
}
