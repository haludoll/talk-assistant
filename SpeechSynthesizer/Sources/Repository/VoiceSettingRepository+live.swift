//
//  Untitled.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import SpeechSynthesizerEntity

extension VoiceSettingRepository {
    package static let live = Self(
        fetchVoiceParameter: { .init() },
        fetchAvailableVoices: { [] }
    )
}
