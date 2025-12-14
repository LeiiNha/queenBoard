//
//  GameStatsView.swift
//  GameStatsView
//
//  Created by Erica Geraldes on 08/12/2025.
//

import SwiftUI

struct GameStatsView: View {
    @ObservedObject var viewModel: GamePlayViewModel

    var body: some View {
        HStack(spacing: 20) {
            StatBadge(
                icon: "crown.fill",
                value: "\(viewModel.queensPlaced)/\(viewModel.boardSize)",
                label: "Queens",
                color: .purple
            )

            StatBadge(
                icon: "timer",
                value: viewModel.formattedTime,
                label: "Time",
                color: .blue
            )

            StatBadge(
                icon: "hand.tap.fill",
                value: "\(viewModel.moveCount)",
                label: "Moves",
                color: .green
            )

            if let bestTime = viewModel.bestTime {
                StatBadge(
                    icon: "star.fill",
                    value: bestTime,
                    label: "Best",
                    color: .yellow
                )
            }
        }
        .padding(.horizontal)
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}
