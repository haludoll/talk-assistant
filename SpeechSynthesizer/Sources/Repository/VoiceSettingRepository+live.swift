//
//  Untitled.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation
import SpeechSynthesizerEntity

extension VoiceSettingRepository {
    package static let live = Self(
        fetchVoiceParameter: { .init() },
        fetchAvailableVoices: { AVSpeechSynthesisVoice.speechVoices().filter { $0.language == Locale.current.language.languageCode?.identifier }}
    )
}
