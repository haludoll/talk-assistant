//
//  VoiceSetting.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation

public struct VoiceSettings {
    public var voices: [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices().filter { $0.language == Locale.current.language.languageCode?.identifier }
    }

    public var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    public let rateRange: Range<Float> = AVSpeechUtteranceMinimumSpeechRate..<AVSpeechUtteranceMaximumSpeechRate
    public var pitchMultiplier: Float = 1.0
    public var volume: Float = 1.0
    
    public var prefersAssistiveTechnologySettings = false
    
    public init() {}
}
