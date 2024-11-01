//
//  VoiceSettingsRepository+live.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation
import SpeechSynthesizerEntity

extension VoiceSettingsRepository {
    package static let live = Self(
        fetchVoiceParameter: { .init() },
        fetchAvailableVoices: { AVSpeechSynthesisVoice.speechVoices() },
        fetchSelectedVoice: { .init(language: Locale.preferredLanguages.first!)! }
    )
}
