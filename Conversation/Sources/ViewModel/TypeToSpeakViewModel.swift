//
//  TypeToSpeakViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/10/24.
//

import Foundation
import SpeechSynthesizerEntity
import SpeechSynthesizerDependency
import Dependencies
import AVFoundation
import FirebaseCrashlytics

@Observable
@MainActor
package final class TypeToSpeakViewModel {
    public var text = ""
    public private(set) var lastText = ""
    public var isSpeaking = false

    @ObservationIgnored
    @Dependency(\.speechSynthesizer) var speechSynthesizer
    @ObservationIgnored
    @Dependency(\.voiceSettingsRepository) private var voiceSettingsRepository

    private var voice: AVSpeechSynthesisVoice?
    private var voiceParameter: VoiceParameter?

    package init() {}

    package func speak() {
        guard !isSpeaking, let voice, let voiceParameter else { return }
        speechSynthesizer.speak(text: text, in: voice, using: voiceParameter)
    }

    package func stop() {
        guard isSpeaking else { return }
        speechSynthesizer.stop()
    }

    package func setupVoice() {
        voice = voiceSettingsRepository.fetchSelectedVoice()
        do {
            voiceParameter = try voiceSettingsRepository.fetchVoiceParameter()
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }

    package func observeSpeechDelegate() async {
        for await action in speechSynthesizer.delegateAsyncChannel {
            switch action {
            case .didStart:
                isSpeaking = true
            case .didFinish:
                isSpeaking = false
                lastText = text
                text = ""
            case .didCancel:
                isSpeaking = false
            }
        }
    }
}
