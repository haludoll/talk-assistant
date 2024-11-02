//
//  SpeechSampleViewModel.swift
//  Settings
//
//  Created by haludoll on 2024/11/02.
//

import Foundation
import AVFoundation
import SpeechSynthesizerDependency
import Dependencies
import SpeechSynthesizerEntity

@Observable
@MainActor
package final class SpeechSampleViewModel {
    public var speakingVoice: AVSpeechSynthesisVoice? = nil

    @ObservationIgnored
    private var willSpeakingVoice: AVSpeechSynthesisVoice? = nil

    public enum SpeakingStatus {
        case none
        case speaking
        case speakingSomeoneElse
    }

    @ObservationIgnored
    @Dependency(\.speechSynthesizer) var speechSynthesizer

    package init() {}

    package func speakSample(text: String, with voice: AVSpeechSynthesisVoice, using voiceParameter: VoiceParameter = .init()) {
        willSpeakingVoice = voice
        speechSynthesizer.speak(text: text, in: voice, using: voiceParameter)
    }

    package func stopSampleText(with voice: AVSpeechSynthesisVoice) {
        speechSynthesizer.stop()
    }

    package func speakingStatus(for voice: AVSpeechSynthesisVoice) -> SpeakingStatus {
        guard let speakingVoice else { return .none }

        if voice == speakingVoice {
            return .speaking
        } else {
            return .speakingSomeoneElse
        }
    }

    package func observeSpeechDelegate() async {
        for await action in speechSynthesizer.delegateAsyncChannel {
            switch action {
            case .didStart:
                speakingVoice = willSpeakingVoice
            case .didFinish,
                 .didCancel:
                speakingVoice = nil
            }
        }
    }
}
