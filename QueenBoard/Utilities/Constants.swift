//
//  Constants.swift
//  QueenBoard
//
//  Created by Erica Geraldes on 08/12/2025.
//

import Foundation
import SwiftUI

enum Constants {
    enum Game {
        static var minimiumBoardNumber: Int = 4
    }

    enum Spacing {
        static var padding: CGFloat = 10
    }

    enum Animation {
        static var `default`: SwiftUI.Animation = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.7)
        static var threeMiliSeconds: SwiftUI.Animation = SwiftUI.Animation.spring(response: 0.3)
        static var easeInOut: SwiftUI.Animation = SwiftUI.Animation.easeInOut(duration: 0.5)
    }

    enum Image {
        static var xmark: SwiftUI.Image = SwiftUI.Image(systemName: "xmark")
        static var chevronLeft: SwiftUI.Image = SwiftUI.Image(systemName: "chevron.left")
    }
}
