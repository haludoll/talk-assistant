//
//  VoiceSettingsRepository+live.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/24.
//

import AVFoundation
import SpeechSynthesizerEntity
import SwiftData

extension VoiceSettingsRepository {
    package static let live = live()

    private static func live(modelContainer: ModelContainer = try! ModelContainer(for: VoiceParameter.self, configurations: .init(isStoredInMemoryOnly: false))) -> Self {
        return .init(
            fetchVoiceParameter: {
                let context = modelContainer.mainContext
                do {
                    if let voiceParam = try context.fetch(FetchDescriptor<VoiceParameter>()).first {
                        return voiceParam
                    } else {
                        let initialVoiceParam = VoiceParameter()
                        context.insert(VoiceParameter())
                        return initialVoiceParam
                    }
                } catch {
                    fatalError()
                }
            },
            updateVoiceParamter: { voiceParam in
                let context = modelContainer.mainContext
                do {
                    try context.delete(model: VoiceParameter.self)
                    context.insert(voiceParam)
                    try context.save()
                } catch {
                    fatalError()
                }
            },
            fetchAvailableVoices: { AVSpeechSynthesisVoice.speechVoices() },
            fetchSelectedVoice: { .init(language: Locale.preferredLanguages.first!)! }
        )
    }
}
