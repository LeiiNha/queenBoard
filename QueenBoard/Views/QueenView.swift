//
//  QueenView.swift
//  QueenBoard
//
//  Created by Erica Geraldes on 14/12/2025.
//

import SwiftUI

struct QueenView: View {
    let isInConflict: Bool
    let squareSize: CGFloat
    @State private var animatingQueen = false

    var body: some View {
        Text("♛")
            .font(.system(size: squareSize * 0.6))
            .foregroundColor(isInConflict ? .red : .purple)
            .shadow(color: .black.opacity(0.2), radius: 2)
            .scaleEffect(animatingQueen ? 1.0 : 0.5)
            .onAppear {
                withAnimation(Constants.Animation.default) {
                    animatingQueen = true
                }
            }

        if isInConflict {
            Circle()
                .stroke(Color.red, lineWidth: 2)
                .frame(width: squareSize * 0.8, height: squareSize * 0.8)
        }
    }
}
