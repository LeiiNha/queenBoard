//
//  ChessSquareView.swift
//  ChessSquareView
//
//  Created by Erica Geraldes on 08/12/2025.
//

import SwiftUI

struct ChessSquareView: View {
    let position: Position
    let squareSize: CGFloat
    @ObservedObject var viewModel: GamePlayViewModel

    private var isLightSquare: Bool {
        (position.row + position.column) % 2 == 0
    }

    private var isInConflict: Bool {
        guard let queen = viewModel.boardState.queen(at: position) else {
            return false
        }
        return !viewModel.boardState.conflicts(for: queen).isEmpty
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(width: squareSize, height: squareSize)

            if viewModel.isSafe(for: position) {
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: squareSize * 0.25, height: squareSize * 0.25)
                    .scaleEffect(animatingSafeIndicator ? 1.0 : 0.8)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: animatingSafeIndicator)
                    .onAppear { animatingSafeIndicator = true }
            }

            if viewModel.isPositionThreatened(position) &&
                viewModel.showHints &&
                !viewModel.boardState.hasQueen(at: position) {
                Constants.Image.xmark
                    .font(.system(size: squareSize * 0.3))
                    .foregroundColor(.red.opacity(0.3))
            }

            if viewModel.boardState.hasQueen(at: position) {
                QueenView(isInConflict: isInConflict, squareSize: squareSize)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleQueen(at: position)
        }
    }

    @State private var animatingSafeIndicator = false

    private var backgroundColor: Color {
        if viewModel.boardState.hasQueen(at: position) && isInConflict {
            return Color.red.opacity(0.2)
        } else if viewModel.boardState.hasQueen(at: position) {
            return Color.blue.opacity(0.15)
        } else if isLightSquare {
            return Color.white
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}
