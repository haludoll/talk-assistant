//
//  VoiceSetting.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation

public struct VoiceParameter {
    public var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    public let rateRange: Range<Float> = AVSpeechUtteranceMinimumSpeechRate..<AVSpeechUtteranceMaximumSpeechRate
    public var pitchMultiplier: Float = 1.0
    public var volume: Float = 1.0
    public var prefersAssistiveTechnologySettings = false
}

public struct VoiceSettingRepository {
    public let fetchVoiceParameter: () -> VoiceParameter
    public let fetchAvailableVoices: () -> [AVSpeechSynthesisVoice]

    public init(fetchVoiceParameter: @escaping () -> VoiceParameter, fetchAvailableVoices: @escaping () -> [AVSpeechSynthesisVoice]) {
        self.fetchVoiceParameter = fetchVoiceParameter
        self.fetchAvailableVoices = fetchAvailableVoices
    }
}
