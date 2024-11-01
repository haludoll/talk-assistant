//
//  VoiceSettingsViewModel.swift
//  Settings
//
//  Created by haludoll on 2024/10/24.
//

import Foundation
import SpeechSynthesizerEntity
import SpeechSynthesizerDependency
import Dependencies
import class AVFoundation.AVSpeechSynthesisVoice

@Observable
@MainActor
package final class VoiceSettingsViewModel {
    public var rate: Float = 0.5
    public var pitchMultiplier: Float = 1.0
    public var volume: Float = 1.0
    public var prefersAssistiveTechnologySettings = false

    public var availableVoices: [AVSpeechSynthesisVoice] = []

    public static let rateRange = VoiceParameter.rateRange
    public static let defaultRate = VoiceParameter.defaultRate
    public static let pitchRange = VoiceParameter.pitchRange
    public static let volumeRange = VoiceParameter.volumeRange

    @ObservationIgnored
    @Dependency(\.voiceSettingsRepository) private var voiceSettingsRepository

    package init() {}

    package func fetchVoiceParameter() {
        let param = voiceSettingsRepository.fetchVoiceParameter()
        rate = param.rate
        pitchMultiplier = param.pitchMultiplier
        volume = param.volume
        prefersAssistiveTechnologySettings = param.prefersAssistiveTechnologySettings
    }

    package func fetchAvailableVoices() {
        availableVoices = voiceSettingsRepository.fetchAvailableVoices().filter { $0.language == Locale.preferredLanguages.first }
    }

    package func updateParam() {}
}
