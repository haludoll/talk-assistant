//
//  VoiceSettingRepository+preview.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import SpeechSynthesizerEntity

extension VoiceSettingRepository {
    static let preview = Self(
        fetchVoiceParameter: { .init() },
        fetchAvailableVoices: { [] }
    )
}
