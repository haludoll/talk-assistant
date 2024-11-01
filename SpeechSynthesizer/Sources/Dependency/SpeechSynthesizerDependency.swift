//
//  SpeechSynthesizerDependency.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import Foundation
import SpeechSynthesizerEntity
import SpeechSynthesizerRepository
import Dependencies

enum SpeechSynthesizerKey: DependencyKey {
    public static let liveValue: any SpeechSynthesizerProtocol = SpeechSynthesizer()
}

extension VoiceSettingsRepository: DependencyKey {
    public static let liveValue = VoiceSettingsRepository.live
}

extension DependencyValues {
    public var speechSynthesizer: any SpeechSynthesizerProtocol {
        get { self[SpeechSynthesizerKey.self] }
        set { self[SpeechSynthesizerKey.self] = newValue }
    }

    public var voiceSettingsRepository: VoiceSettingsRepository {
        get { self[VoiceSettingsRepository.self] }
        set { self[VoiceSettingsRepository.self] = newValue }
    }
}
