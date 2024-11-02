//
//  VoiceSettingsRepository.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation

public struct VoiceParameter: Codable {
    public var rate: Float
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

extension VoiceParameter {
    public static let rateRange: ClosedRange<Float> = AVSpeechUtteranceMinimumSpeechRate...AVSpeechUtteranceMaximumSpeechRate
    public static let defaultRate: Float = AVSpeechUtteranceDefaultSpeechRate
    public static let pitchRange: ClosedRange<Float> = 0.5...1.5
    public static let volumeRange: ClosedRange<Float> = 0...1.0
}

public struct VoiceSettingsRepository: Sendable {
    public let fetchVoiceParameter: @Sendable () throws -> VoiceParameter
    public let updateVoiceParamter: @Sendable (VoiceParameter) throws -> Void
    public let fetchAvailableVoices: @Sendable () -> [AVSpeechSynthesisVoice]
    public let fetchSelectedVoice: @Sendable () -> AVSpeechSynthesisVoice
    public let updateSelectedVoice: @Sendable (AVSpeechSynthesisVoice) -> Void

    public init(fetchVoiceParameter: @escaping @Sendable () throws -> VoiceParameter,
                updateVoiceParamter: @escaping @Sendable (VoiceParameter) throws -> Void,
                fetchAvailableVoices: @escaping @Sendable () -> [AVSpeechSynthesisVoice],
                fetchSelectedVoice: @escaping @Sendable () -> AVSpeechSynthesisVoice,
                updateSelectedVoice: @escaping @Sendable (AVSpeechSynthesisVoice) -> Void) {
        self.fetchVoiceParameter = fetchVoiceParameter
        self.updateVoiceParamter = updateVoiceParamter
        self.fetchAvailableVoices = fetchAvailableVoices
        self.fetchSelectedVoice = fetchSelectedVoice
        self.updateSelectedVoice = updateSelectedVoice
    }
}
