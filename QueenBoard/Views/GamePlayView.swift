//
//  GamePlayView.swift
//  GamePlayView
//
//  Created by Erica Geraldes on 08/12/2025.
//

import SwiftUI

struct GamePlayView: View {
    @StateObject private var viewModel: GamePlayViewModel
    @Environment(\.dismiss) private var dismiss

    init(configuration: GameConfiguration) {
        _viewModel = StateObject(wrappedValue: GamePlayViewModel(configuration: configuration))
    }

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                topBarView

                GameStatsView(viewModel: viewModel)

                if let error = viewModel.errorMessage {
                    errorBanner(error)
                }

                ChessBoardView(viewModel: viewModel)
                    .padding(.horizontal)

                controlsView

                Spacer()
            }
            .padding(.top)

            if viewModel.showVictory {
                VictoryView(
                    boardSize: viewModel.boardSize,
                    moves: viewModel.moveCount,
                    time: viewModel.formattedTime,
                    isNewRecord: viewModel.bestTime == viewModel.formattedTime,
                    onPlayAgain: {
                        viewModel.resetGame()
                    },
                    onExit: {
                        dismiss()
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showStatistics) {
            StatisticsView(statistics: PersistenceService().loadStatistics())
        }
    }

    //MARK: - Assisting views

    private var topBarView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Constants.Image.chevronLeft
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }

            Spacer()

            Text("\(viewModel.boardSize)×\(viewModel.boardSize) Board")
                .font(.headline)

            Spacer()

            Button(action: { viewModel.soundEnabled.toggle() }) {
                Image(systemName: viewModel.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }

    private func errorBanner(_ message: String) -> some View {
        Text(message)
            .font(.subheadline.bold())
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.red)
                    .shadow(radius: 5)
            )
            .transition(.move(edge: .top).combined(with: .opacity))
    }

    private var controlsView: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                Button(action: { viewModel.showHints.toggle() }) {
                    Label(viewModel.showHints ? "Hide Hints" : "Show Hints",
                          systemImage: viewModel.showHints ? "lightbulb.fill" : "lightbulb")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.showHints ? Color.orange : Color.blue)
                        .cornerRadius(12)
                }

                Button(action: { viewModel.resetGame() }) {
                    Label("Reset", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }
}
