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

extension VoiceSettingRepository: DependencyKey {
    public static var liveValue: VoiceSettingRepository { .live }
}

extension DependencyValues {
    public var speechSynthesizer: any SpeechSynthesizerProtocol {
        get { self[SpeechSynthesizerKey.self] }
        set { self[SpeechSynthesizerKey.self] = newValue }
    }

    public var voiceSettingRepository: VoiceSettingRepository {
        get { self[VoiceSettingRepository.self] }
        set { self[VoiceSettingRepository.self] = newValue }
    }
}
