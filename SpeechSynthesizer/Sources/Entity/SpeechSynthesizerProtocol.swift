//
//  SpeechSynthesizerProtocol.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AsyncAlgorithms
import AVFoundation

public enum SpeechSynthesizerDelegateAction: Sendable {
    case didStart
    case didFinish
    case didCancel
}

@MainActor
public protocol SpeechSynthesizerProtocol: Sendable {
    var delegateAsyncChannel: AsyncChannel<SpeechSynthesizerDelegateAction> { get }
    func speak(text: String, in voice: AVSpeechSynthesisVoice, using voiceParameter: VoiceParameter)
    func stop()
}
