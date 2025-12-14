//
//  GameSetupView.swift
//  GameSetupView
//
//  Created by Erica Geraldes on 08/12/2025.
//

import SwiftUI

enum Route: Hashable {
    case game
    case stats
}

struct GameSetupView: View {
    @StateObject private var viewModel = GameSetupViewModel()
    @State private var path = NavigationPath()
    @State private var navigateToGame = false
    @State private var showStatistics = false

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        headerView

                        difficultySelectionView

                        statisticsPreviewView

                        startButtonView

                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .game:
                    GamePlayView(configuration: viewModel.createConfiguration())
                case .stats:
                    StatisticsView(statistics: viewModel.statistics)
                }
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 15) {
            Text("♛")
                .font(.system(size: 80))
                .shadow(radius: 5)

            Text("N-Queens Puzzle")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text("Place N queens on an N×N board\nwithout conflicts")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
    }

    private var difficultySelectionView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select Difficulty")
                .font(.title2.bold())
                .foregroundColor(.primary)

            ForEach(GameConfiguration.Difficulty.allCases, id: \.self) { difficulty in
                DifficultyCard(
                    difficulty: difficulty,
                    isSelected: viewModel.selectedDifficulty == difficulty,
                    bestTime: viewModel.getBestTime(for: difficulty)
                ) {
                    withAnimation(Constants.Animation.threeMiliSeconds) {
                        viewModel.selectedDifficulty = difficulty
                        if difficulty == .custom {
                            viewModel.showCustomSizeInput = true
                        } else {
                            viewModel.showCustomSizeInput = false
                        }
                    }
                }
            }

            if viewModel.showCustomSizeInput {
                CustomSizeInputView(boardSize: $viewModel.customBoardSize)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }

    private var statisticsPreviewView: some View {
        HStack(spacing: 30) {
            StatCard(
                title: "Games Won",
                value: "\(viewModel.statistics.gamesWon)",
                icon: "trophy.fill",
                color: .yellow
            )

            StatCard(
                title: "Win Rate",
                value: String(format: "%.0f%%", viewModel.statistics.winRate),
                icon: "chart.line.uptrend.xyaxis",
                color: .green
            )
        }
        .padding(.horizontal)
    }

    private var startButtonView: some View {
        VStack(spacing: 15) {
            Button(action: {
                path.append(Route.game)
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Game")
                        .font(.title3.bold())
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
            }

            Button(action: {
                path.append(Route.stats)
            }) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                    Text("View Statistics")
                        .font(.headline)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

struct DifficultyCard: View {
    let difficulty: GameConfiguration.Difficulty
    let isSelected: Bool
    let bestTime: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(difficulty.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)

                    if let bestTime = bestTime {
                        Text("Best: \(bestTime)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomSizeInputView: View {
    @Binding var boardSize: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Board Size: \(boardSize)×\(boardSize)")
                .font(.subheadline.bold())

            Stepper("", value: $boardSize, in: 4...16)
                .labelsHidden()

            Text("Minimum: 4, Maximum: 16")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(10)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)

            Text(value)
                .font(.title.bold())
                .foregroundColor(.primary)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}
