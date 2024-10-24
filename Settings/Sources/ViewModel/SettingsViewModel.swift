//
//  SettingsViewModel.swift
//  Settings
//
//  Created by haludoll on 2024/10/24.
//

import Foundation
import SpeechSynthesizerEntity
import SpeechSynthesizerDependency
import Dependencies

@Observable
@MainActor
package final class SettingsViewModel {
    public var rate: Float = 0.5
    public var pitchMultiplier: Float = 1.0
    public var volume: Float = 1.0
    public var prefersAssistiveTechnologySettings = false

    public static let rateRange = VoiceParameter.rateRange
    public static let defaultRate = VoiceParameter.defaultRate
    public static let pitchRange = VoiceParameter.pitchRange
    public static let volumeRange = VoiceParameter.volumeRange

    @ObservationIgnored
    @Dependency(\.voiceSettingRepository) private var voiceSettingRepository

    package init() {}

    package func fetchVoiceParameter() {
        let param = voiceSettingRepository.fetchVoiceParameter()
        rate = param.rate
        pitchMultiplier = param.pitchMultiplier
        volume = param.volume
        prefersAssistiveTechnologySettings = param.prefersAssistiveTechnologySettings
    }

    package func updateParam() {}
}
