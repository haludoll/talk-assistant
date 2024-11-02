//
//  VoiceSettingsRepository+live.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation
import SpeechSynthesizerEntity
import Foundation

extension VoiceSettingsRepository {
    private static let voiceParameterUserDefaultsKey = "voice_parameter"
    private static let selectedVoiceIDUserDefaultsKey = "selected_voice_id"
    package static let live = live()

    private static func live(userDefaults: UserDefaults = .standard) -> Self {
        return .init(
            fetchVoiceParameter: {
                if let data = userDefaults.data(forKey: Self.voiceParameterUserDefaultsKey) {
                    return try JSONDecoder().decode(VoiceParameter.self, from: data)
                } else {
                    let initialParam = VoiceParameter()
                    userDefaults.set(try JSONEncoder().encode(initialParam), forKey: Self.voiceParameterUserDefaultsKey)
                    return initialParam
                }
            },
            updateVoiceParamter: { voiceParam in
                userDefaults.set(try JSONEncoder().encode(voiceParam), forKey: Self.voiceParameterUserDefaultsKey)
            },
            fetchAvailableVoices: { AVSpeechSynthesisVoice.speechVoices() },
            fetchSelectedVoice: {
                if let id = userDefaults.string(forKey: Self.selectedVoiceIDUserDefaultsKey),
                   let voice = AVSpeechSynthesisVoice(identifier: id) {
                    return voice
                } else {
                    let initialVoice = AVSpeechSynthesisVoice()
                    userDefaults.set(initialVoice.identifier, forKey: Self.selectedVoiceIDUserDefaultsKey)
                    return initialVoice
                }
            },
            updateSelectedVoice: { voice in
                userDefaults.set(voice.identifier, forKey: Self.selectedVoiceIDUserDefaultsKey)
            }
        )
    }
}

extension UserDefaults: @unchecked @retroactive Sendable {}
