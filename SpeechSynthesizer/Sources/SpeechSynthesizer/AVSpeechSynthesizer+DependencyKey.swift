//
//  AVSpeechSynthesizer+DependencyKey.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/21.
//

import AVFoundation
import Dependencies

protocol AVSpeechSynthesizerProtocol: Sendable {
    var delegate: (any AVSpeechSynthesizerDelegate)? { get set }
    var mixToTelephonyUplink: Bool { get set }

    func setup(delegate: any AVSpeechSynthesizerDelegate, mixToTelephonyUplink: Bool)
    func speak(_ utterance: AVSpeechUtterance)
    func stopSpeaking(at boundary: AVSpeechBoundary) -> Bool
}

extension AVSpeechSynthesizer: @unchecked @retroactive Sendable {}
extension AVSpeechSynthesizer: AVSpeechSynthesizerProtocol {
    func setup(delegate: any AVSpeechSynthesizerDelegate, mixToTelephonyUplink: Bool) {
        self.delegate = delegate
        self.mixToTelephonyUplink = mixToTelephonyUplink
    }
}

enum AVSpeechSynthesizerKey: DependencyKey {
    static let liveValue: any AVSpeechSynthesizerProtocol = AVSpeechSynthesizer()
}

extension DependencyValues {
    var avSpeechSynthesizer: any AVSpeechSynthesizerProtocol {
        get { self[AVSpeechSynthesizerKey.self] }
        set { self[AVSpeechSynthesizerKey.self] = newValue }
    }
}
