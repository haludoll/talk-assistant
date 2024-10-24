//
//  VoiceSettingRepository.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation

public struct VoiceParameter: Sendable {
    public var rate: Float
    public let rateRange: Range<Float> = AVSpeechUtteranceMinimumSpeechRate..<AVSpeechUtteranceMaximumSpeechRate
    public var pitchMultiplier: Float
    public var volume: Float
    public var prefersAssistiveTechnologySettings: Bool

    public init(rate: Float = AVSpeechUtteranceDefaultSpeechRate, pitchMultiplier: Float = 1.0, volume: Float = 1.0, prefersAssistiveTechnologySettings: Bool = false) {
        self.rate = rate
        self.pitchMultiplier = pitchMultiplier
        self.volume = volume
        self.prefersAssistiveTechnologySettings = prefersAssistiveTechnologySettings
    }
}

public struct VoiceSettingRepository: Sendable {
    public let fetchVoiceParameter: @Sendable () -> VoiceParameter
    public let fetchAvailableVoices: @Sendable () -> [AVSpeechSynthesisVoice]

    public init(fetchVoiceParameter: @escaping @Sendable () -> VoiceParameter, fetchAvailableVoices: @escaping @Sendable () -> [AVSpeechSynthesisVoice]) {
        self.fetchVoiceParameter = fetchVoiceParameter
        self.fetchAvailableVoices = fetchAvailableVoices
    }
}
