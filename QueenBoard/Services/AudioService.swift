//
//  AudioService.swift
//  AudioService
//
//  Created by Erica Geraldes on 08/12/2025.
//

import AVFoundation
import SwiftUI

protocol AudioServiceProtocol {
    func playPlacementSound()
    func playRemovalSound()
    func playErrorSound()
    func playVictorySound()
    func setEnabled(_ enabled: Bool)
}

final class AudioService: AudioServiceProtocol {
    private var isEnabled = true

    init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    func playPlacementSound() {
        guard isEnabled else { return }
        playSystemSound(1104) // Tock sound
    }

    func playRemovalSound() {
        guard isEnabled else { return }
        playSystemSound(1105) // Tink sound
    }

    func playErrorSound() {
        guard isEnabled else { return }
        playSystemSound(1053) // Alert sound
    }

    func playVictorySound() {
        guard isEnabled else { return }
        playSystemSound(1025) // Success sound
    }

    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
}
