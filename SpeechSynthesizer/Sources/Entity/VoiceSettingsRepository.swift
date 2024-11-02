//
//  VoiceSettingsRepository.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation
import SwiftData

@Model
public final class VoiceParameter {
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
    public let fetchVoiceParameter: @MainActor () -> VoiceParameter
    public let updateVoiceParamter: @MainActor (VoiceParameter) -> Void
    public let fetchAvailableVoices: @Sendable () -> [AVSpeechSynthesisVoice]
    public let fetchSelectedVoice: @MainActor () -> AVSpeechSynthesisVoice

    public init(fetchVoiceParameter: @escaping @MainActor () -> VoiceParameter,
                updateVoiceParamter: @escaping @MainActor (VoiceParameter) -> Void,
                fetchAvailableVoices: @escaping @Sendable () -> [AVSpeechSynthesisVoice],
                fetchSelectedVoice: @escaping @MainActor () -> AVSpeechSynthesisVoice) {
        self.fetchVoiceParameter = fetchVoiceParameter
        self.updateVoiceParamter = updateVoiceParamter
        self.fetchAvailableVoices = fetchAvailableVoices
        self.fetchSelectedVoice = fetchSelectedVoice
    }
}
