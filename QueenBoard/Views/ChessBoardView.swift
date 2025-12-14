//
//  ChessBoardView.swift
//  ChessBoardView
//
//  Created by Erica Geraldes on 08/12/2025.
//

import SwiftUI

struct ChessBoardView: View {
    @ObservedObject var viewModel: GamePlayViewModel

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let squareSize = size / CGFloat(viewModel.boardSize)

            VStack(spacing: 0) {
                ForEach(0..<viewModel.boardSize, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<viewModel.boardSize, id: \.self) { column in
                            ChessSquareView(
                                position: Position(row, column),
                                squareSize: squareSize,
                                viewModel: viewModel
                            )
                        }
                    }
                }
            }
            .frame(width: size, height: size)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
