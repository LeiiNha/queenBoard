//
//  VictoryView.swift
//  VictoryView
//
//  Created by Erica Geraldes on 08/12/2025.
//

import SwiftUI

struct VictoryView: View {
    let boardSize: Int
    let moves: Int
    let time: String
    let isNewRecord: Bool
    let onPlayAgain: () -> Void
    let onExit: () -> Void

    @State private var scale: CGFloat = 0.5
    @State private var rotation: Double = 0
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { }

            VStack(spacing: 25) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(showConfetti ? 1.2 : 1.0)
                        .opacity(showConfetti ? 0.5 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(), value: showConfetti)

                    Text("🏆")
                        .font(.system(size: 70))
                        .rotationEffect(.degrees(rotation))
                        .scaleEffect(scale)
                }

                VStack(spacing: 10) {
                    Text("Victory!")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)

                    if isNewRecord {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("New Record!")
                            Image(systemName: "star.fill")
                        }
                        .font(.headline)
                        .foregroundColor(.yellow)
                    }

                    Text("You solved the \(boardSize)×\(boardSize) puzzle!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 15) {
                    HStack(spacing: 40) {
                        VictoryStatView(icon: "timer", label: "Time", value: time, color: .blue)
                        VictoryStatView(icon: "hand.tap.fill", label: "Moves", value: "\(moves)", color: .green)
                    }
                }
                .padding(.vertical)

                VStack(spacing: 12) {
                    Button(action: onPlayAgain) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Play Again")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }

                    Button(action: onExit) {
                        Text("Exit to Menu")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: .black.opacity(0.3), radius: 20)
            )
            .padding(.horizontal, 40)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(Constants.Animation.default) {
                scale = 1.0
            }
            withAnimation(Constants.Animation.easeInOut) {
                rotation = 360
            }
            showConfetti = true
        }
    }
}

struct VictoryStatView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title2.bold())
                .foregroundColor(.primary)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
