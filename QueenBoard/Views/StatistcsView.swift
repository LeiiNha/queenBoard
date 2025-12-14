//
//  StatisticsView.swift
//  StatisticsView
//
//  Created by Erica Geraldes on 08/12/2025.
//

import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel: StatisticsViewModel
    @Environment(\.dismiss) private var dismiss

    init(statistics: GameStatistics) {
        let persistenceService = PersistenceService()
        _viewModel = StateObject(wrappedValue: StatisticsViewModel(persistenceService: persistenceService))
    }

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.hasStatistics {
                    statisticsContent
                } else {
                    emptyStateView
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.hasStatistics {
                        Button(role: .destructive) {
                            viewModel.showClearConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Clear Statistics", isPresented: $viewModel.showClearConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    viewModel.clearAllStatistics()
                }
            } message: {
                Text("Are you sure you want to clear all statistics? This action cannot be undone.")
            }
        }
    }

    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 25) {
                overviewSection

                detailedStatsSection

                bestTimesSection

                Spacer(minLength: 20)
            }
            .padding()
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.5))

            Text("No Statistics Yet")
                .font(.title2.bold())
                .foregroundColor(.primary)

            Text("Start playing to see your statistics here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Overview")
                .font(.title2.bold())

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                StatisticCard(
                    title: "Games Played",
                    value: "\(viewModel.statistics.gamesPlayed)",
                    icon: "gamecontroller.fill",
                    color: .blue
                )

                StatisticCard(
                    title: "Games Won",
                    value: "\(viewModel.statistics.gamesWon)",
                    icon: "trophy.fill",
                    color: .yellow
                )

                StatisticCard(
                    title: "Win Rate",
                    value: viewModel.getStatsSummary().formattedWinRate,
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green
                )

                StatisticCard(
                    title: "Total Moves",
                    value: "\(viewModel.statistics.totalMoves)",
                    icon: "hand.tap.fill",
                    color: .purple
                )
            }
        }
    }

    private var detailedStatsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detailed Stats")
                .font(.title2.bold())

            VStack(spacing: 12) {
                DetailedStatRow(
                    icon: "number",
                    label: "Average Moves per Game",
                    value: viewModel.getStatsSummary().formattedAverageMoves,
                    color: .orange
                )

                DetailedStatRow(
                    icon: "star.fill",
                    label: "Best Times Recorded",
                    value: "\(viewModel.statistics.bestTimes.count)",
                    color: .yellow
                )

                if viewModel.statistics.gamesPlayed > 0 {
                    DetailedStatRow(
                        icon: "xmark.circle.fill",
                        label: "Games Lost",
                        value: "\(viewModel.statistics.gamesPlayed - viewModel.statistics.gamesWon)",
                        color: .red
                    )
                }
            }
        }
    }

    private var bestTimesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Best Times")
                    .font(.title2.bold())

                Spacer()

                if !viewModel.sortedBestTimes.isEmpty {
                    Text("\(viewModel.sortedBestTimes.count) records")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if viewModel.sortedBestTimes.isEmpty {
                Text("No records yet. Win a game to set your first record!")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
            } else {
                ForEach(viewModel.sortedBestTimes, id: \.boardSize) { record in
                    BestTimeRow(
                        boardSize: record.boardSize,
                        time: record.time,
                        formattedTime: viewModel.formattedTime(for: record.time),
                        onDelete: {
                            viewModel.clearBestTime(for: record.boardSize)
                        }
                    )
                }
            }
        }
    }
}

struct DetailedStatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

struct BestTimeRow: View {
    let boardSize: Int
    let time: TimeInterval
    let formattedTime: String
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(boardSize)×\(boardSize) Board")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("Best time achieved")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 8) {
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 5) {
                        Image(systemName: "timer")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text(formattedTime)
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                    }
                }

                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red.opacity(0.7))
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .alert("Delete Record", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete the best time for \(boardSize)×\(boardSize) board?")
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)

            Text(value)
                .font(.title.bold())
                .foregroundColor(.primary)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(15)
    }
}
