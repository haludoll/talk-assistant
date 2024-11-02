//
//  VoiceSelectionView.swift
//  Settings
//
//  Created by haludoll on 2024/10/24.
//

import SwiftUI
import SettingsViewModel
import AVFoundation
import TipKit

struct VoiceSelectionView: View {
    let voiceSettingsViewModel: VoiceSettingsViewModel

    @State private var speechSampleViewModel = SpeechSampleViewModel()
    @Environment(\.dismiss) private var dismiss
    private var additionalVoiceDownloadTip = AdditionalVoiceDownloadTip()

    init(voiceSettingsViewModel: VoiceSettingsViewModel) {
        self.voiceSettingsViewModel = voiceSettingsViewModel

        try? Tips.configure([.displayFrequency(.monthly)])
    }

    var body: some View {
        List {
            TipView(additionalVoiceDownloadTip)
                .tipBackground(Color(.secondarySystemGroupedBackground))
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

            ForEach(AVSpeechSynthesisVoiceGender.allCases) { gender in
                let voices = voiceSettingsViewModel.availableVoices.filter { $0.gender == gender }
                if !voices.isEmpty {
                    Section(gender.name) {
                        ForEach(voices) { voice in
                            Button {
                                voiceSettingsViewModel.updateSelectedVoice(voice)
                                dismiss()
                            } label: {
                                Label {
                                    LabeledContent {
                                        if let selectedVoice = voiceSettingsViewModel.selectedVoice,
                                           voice == selectedVoice {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(Color.accentColor)
                                        }
                                    } label: {
                                        Text(voice.name)
                                            .foregroundStyle(Color.primary)
                                    }
                                } icon: {
                                    PlaySampleButton(voice: voice, speechSampleViewModel: speechSampleViewModel)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Voice", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await speechSampleViewModel.observeSpeechDelegate()
        }
    }
}

private struct PlaySampleButton: View {
    let voice: AVSpeechSynthesisVoice
    let speechSampleViewModel: SpeechSampleViewModel
    private let sampleText = String(localized: "This is a sample sentence. I can speak English sentences.", bundle: .module)

    init(voice: AVSpeechSynthesisVoice, speechSampleViewModel: SpeechSampleViewModel) {
        self.voice = voice
        self.speechSampleViewModel = speechSampleViewModel
    }

    var body: some View {
        Button {
            switch speechSampleViewModel.speakingStatus(for: voice) {
            case .none:
                speechSampleViewModel.speakSample(text: sampleText, with: voice)
            case .speaking:
                speechSampleViewModel.stopSampleText(with: voice)
            case .speakingSomeoneElse:
                speechSampleViewModel.stopSampleText(with: voice)
                speechSampleViewModel.speakSample(text: sampleText, with: voice)
            }
        } label: {
            if let speakingVoice = speechSampleViewModel.speakingVoice,
               speakingVoice == voice {
                Image(systemName: "stop.circle")
            } else {
                Image(systemName: "play.circle")
            }
        }
        .foregroundStyle(Color.accentColor)
    }
}

#Preview {
    VoiceSelectionView(voiceSettingsViewModel: .init())
}

extension AVSpeechSynthesisVoiceGender: @retroactive CaseIterable {
    public static var allCases: [Self] { [.male, .female, .unspecified] }
}

extension AVSpeechSynthesisVoiceGender: @retroactive Identifiable {
    public var id: Self { self }
}

private extension AVSpeechSynthesisVoiceGender {
    var name: String {
        switch self {
        case .unspecified: String(localized: "Others", bundle: .module)
        case .male: String(localized: "Male", bundle: .module)
        case .female: String(localized: "Female", bundle: .module)
        @unknown default:
            fatalError()
        }
    }
}

private extension SpeechSampleViewModel.SpeakingStatus {
    var image: Image {
        switch self {
        case .none,
             .speakingSomeoneElse:
            Image(systemName: "play.circle")
        case .speaking:
            Image(systemName: "stop.circle")
        }
    }
}

extension AVSpeechSynthesisVoice: @retroactive Identifiable {
    public var id: String { identifier }
}

private struct AdditionalVoiceDownloadTip: Tip {
    var title: Text {
        Text("Download additional voices", bundle: .module)
    }

    var message: Text? {
        Text("Additional voices can be downloaded from the device Settings app > Accessibility > Spoken Content > Voices.", bundle: .module)
            .font(.footnote)
    }

    var image: Image? {
        Image(systemName: "arrow.down.circle")
    }
}
