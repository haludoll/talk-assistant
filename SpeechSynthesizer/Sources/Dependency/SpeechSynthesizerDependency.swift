//
//  SpeechSynthesizerDependency.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import SpeechSynthesizerEntity
import SpeechSynthesizerRepository
import Dependencies

enum SpeechSynthesizerKey: DependencyKey {
    public static let liveValue: any SpeechSynthesizerProtocol = SpeechSynthesizer()
}

extension DependencyValues {
    public var speechSynthesizer: any SpeechSynthesizerProtocol {
        get { self[SpeechSynthesizerKey.self] }
        set { self[SpeechSynthesizerKey.self] = newValue }
    }
}
