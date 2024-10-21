//
//  AVAudioSession+configure.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/21.
//

import AVFoundation

extension AVAudioSession {
    static func configure() {
        do {
            try Self.sharedInstance().setCategory(.playback, mode: .voicePrompt)
        } catch {
            // TODO: Logging error
        }
    }
}
