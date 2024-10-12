//
//  SpeechSynthesizer.swift
//  Conversation
//
//  Created by shota-nishizawa on 2024/10/12.
//

import AVFoundation

@Observable
public final class SpeechSynthesizer {
    public var text = ""
    private let avSpeechSynthesizer = {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.mixToTelephonyUplink = true
        return synthesizer
    }()

    public init() {}

    public func speak(_ text: String) {
        let utterance =  AVSpeechUtterance(string: text)
        // TODO: - Allow users to toggle whether or not they want to inherit the values of the Assistive Technology Settings.
        utterance.prefersAssistiveTechnologySettings = true
        avSpeechSynthesizer.speak(utterance)
    }
}
