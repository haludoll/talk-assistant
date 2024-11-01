//
//  VoiceSettingsRepository.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation

public struct VoiceParameter: Sendable {
    public var rate: Float
    public var pitchMultiplier: Float
    public var volume: Float
    public var prefersAssistiveTechnologySettings: Bool

    public static let rateRange: ClosedRange<Float> = AVSpeechUtteranceMinimumSpeechRate...AVSpeechUtteranceMaximumSpeechRate
    public static let defaultRate: Float = AVSpeechUtteranceDefaultSpeechRate
    public static let pitchRange: ClosedRange<Float> = 0.5...1.5
    public static let volumeRange: ClosedRange<Float> = 0...1.0

    public init(rate: Float = AVSpeechUtteranceDefaultSpeechRate, pitchMultiplier: Float = 1.0, volume: Float = 1.0, prefersAssistiveTechnologySettings: Bool = false) {
        self.rate = rate
        self.pitchMultiplier = pitchMultiplier
        self.volume = volume
        self.prefersAssistiveTechnologySettings = prefersAssistiveTechnologySettings
    }
}

public struct VoiceSettingsRepository: Sendable {
    public let fetchVoiceParameter: @Sendable () -> VoiceParameter
    public let fetchAvailableVoices: @Sendable () -> [AVSpeechSynthesisVoice]

    public init(fetchVoiceParameter: @escaping @Sendable () -> VoiceParameter, fetchAvailableVoices: @escaping @Sendable () -> [AVSpeechSynthesisVoice]) {
        self.fetchVoiceParameter = fetchVoiceParameter
        self.fetchAvailableVoices = fetchAvailableVoices
    }
}
