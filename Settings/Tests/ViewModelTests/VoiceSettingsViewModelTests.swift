//
//  VoiceSettingsViewModelTests.swift
//  Settings
//
//  Created by haludoll on 2024/11/01.
//

import Testing
import Dependencies
import SpeechSynthesizerEntity
import AVFoundation
@testable import SettingsViewModel

@MainActor
struct VoiceSettingsViewModelTests {
    @Test func fetchAvailableVoices_filter_current_language() {
        let sut = withDependencies {
            $0.voiceSettingsRepository = .init(fetchVoiceParameter: { .init() },
                                               updateVoiceParamter: { _ in },
                                               fetchAvailableVoices: { [.init(language: "en-US")!,
                                                                        .init(language: "ja-JP")!,
                                                                        .init(language: "en-AU")!] },
                                               fetchSelectedVoice: { .init() },
                                               updateSelectedVoice: { _ in })
        } operation: {
            VoiceSettingsViewModel(currentLanguageCode: "en-US")
        }

        sut.fetchAvailableVoices()
        #expect(sut.availableVoices == [.init(language: "en-US")!])
    }

    @Test func fetchAvailableVoices_sort_by_name() {
        let sut = withDependencies {
            $0.voiceSettingsRepository = .init(fetchVoiceParameter: { .init() },
                                               updateVoiceParamter: { _ in },
                                               fetchAvailableVoices: { [.init(identifier: "com.apple.voice.compact.en-US.Samantha")!,
                                                                        .init(identifier: "com.apple.speech.synthesis.voice.Albert")!] },
                                               fetchSelectedVoice: { .init() },
                                               updateSelectedVoice: { _ in })
        } operation: {
            VoiceSettingsViewModel(currentLanguageCode: "en-US")
        }
        sut.fetchAvailableVoices()
        #expect(sut.availableVoices.map(\.name) == ["Albert", "Samantha"])
    }
}
