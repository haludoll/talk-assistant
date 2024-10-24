//
//  SpeechSynthesizer.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/12.
//

import AVFoundation
import AsyncAlgorithms
import SpeechSynthesizerEntity

@MainActor
package final class SpeechSynthesizer: NSObject, Sendable, SpeechSynthesizerProtocol {
    package let delegateAsyncChannel = AsyncChannel<SpeechSynthesizerDelegateAction>()

    private let avSpeechSynthesizer = AVSpeechSynthesizer()
    private var willStopSpeaking = false  // WORKAROUND of `didCancel` delegate bug

    nonisolated public override init() {
        super.init()
        Task { @MainActor in
            avSpeechSynthesizer.delegate = self
            avSpeechSynthesizer.mixToTelephonyUplink = true
        }

        AVAudioSession.configure()
    }

    package func speak(text: String) {
        let utterance =  AVSpeechUtterance(string: text)
        // TODO: - Allow users to toggle whether or not they want to inherit the values of the Assistive Technology Settings.
        utterance.prefersAssistiveTechnologySettings = true
        avSpeechSynthesizer.speak(utterance)
    }

    package func stop() {
        willStopSpeaking = true
        _ = avSpeechSynthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechSynthesizer: @preconcurrency AVSpeechSynthesizerDelegate {
    package func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Task {
            await delegateAsyncChannel.send(.didStart)
        }
    }

    package func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task {
            // WORKAROUND: Due to `didCancel` delegate bug
            if willStopSpeaking {
                await delegateAsyncChannel.send(.didCancel)
                willStopSpeaking = false
            } else {
                await delegateAsyncChannel.send(.didFinish)
            }
        }
    }

    // FIXME: This delegate method is not called even when `stopSpeaking` is called, due to the AVFoundation bug.
    // https://developer.apple.com/forums/thread/691347
    package func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {}
}

private extension AVAudioSession {
    static func configure() {
        do {
            try Self.sharedInstance().setCategory(.playback, mode: .voicePrompt)
        } catch {
            // TODO: Logging error
        }
    }
}
