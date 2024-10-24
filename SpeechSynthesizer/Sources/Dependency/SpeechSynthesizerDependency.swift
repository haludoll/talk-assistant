//
//  SpeechSynthesizerDependency.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import Foundation
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

public struct SpeechSynthesizerDependency {
    public static let voiceSettingRepository: VoiceSettingRepository = {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return .preview
        } else {
            return .live
        }
    }()
}
