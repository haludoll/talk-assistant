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
    public private(set) var selectedVoice: AVSpeechSynthesisVoice?

    public var rate: Float = 0.5
    public var pitchMultiplier: Float = 1.0
    public var volume: Float = 1.0
    public var prefersAssistiveTechnologySettings = false

    public var voiceParameter: VoiceParameter {
        .init(rate: rate,
              pitchMultiplier: pitchMultiplier,
              volume: volume,
              prefersAssistiveTechnologySettings: prefersAssistiveTechnologySettings)
    }

    public private(set) var availableVoices: [AVSpeechSynthesisVoice] = []

    public static let rateRange = VoiceParameter.rateRange
    public static let defaultRate = VoiceParameter.defaultRate
    public static let pitchRange = VoiceParameter.pitchRange
    public static let volumeRange = VoiceParameter.volumeRange

    @ObservationIgnored
    @Dependency(\.voiceSettingsRepository) private var voiceSettingsRepository

    private let currentLanguageCode: String

    package init(currentLanguageCode: String = AVSpeechSynthesisVoice.currentLanguageCode()) {
        self.currentLanguageCode = currentLanguageCode
    }

    package func fetchVoiceParameter() {
        do {
            let param = try voiceSettingsRepository.fetchVoiceParameter()
            rate = param.rate
            pitchMultiplier = param.pitchMultiplier
            volume = param.volume
            prefersAssistiveTechnologySettings = param.prefersAssistiveTechnologySettings
        } catch {
            // TODO: record error
        }
    }

    package func fetchAvailableVoices() {
        availableVoices = voiceSettingsRepository
            .fetchAvailableVoices()
            .filter { $0.language == currentLanguageCode }
            .sorted(by: { $0.name < $1.name })
    }

    package func fetchSelectedVoice() {
        selectedVoice = voiceSettingsRepository.fetchSelectedVoice()
    }

    package func updateVoiceParam() {
        do {
            try voiceSettingsRepository.updateVoiceParamter(.init(rate: self.rate,
                                                                  pitchMultiplier: self.pitchMultiplier,
                                                                  volume: self.volume,
                                                                  prefersAssistiveTechnologySettings: self.prefersAssistiveTechnologySettings))
        } catch {
            // TODO: record error
        }
    }
    
    package func updateSelectedVoice(_ voice: AVSpeechSynthesisVoice) {
        voiceSettingsRepository.updateSelectedVoice(voice)
    }
}
