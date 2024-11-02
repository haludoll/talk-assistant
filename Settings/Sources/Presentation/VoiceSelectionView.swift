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
    let selectedVoice: AVSpeechSynthesisVoice?
    let availableVoices: [AVSpeechSynthesisVoice]
    let updateSelectedVoice: (AVSpeechSynthesisVoice) -> Void

    @Environment(\.dismiss) private var dismiss

    private var additionalVoiceDownloadTip = AdditionalVoiceDownloadTip()

    init(selectedVoice: AVSpeechSynthesisVoice?,
         availableVoices: [AVSpeechSynthesisVoice],
         updateSelectedVoice: @escaping (AVSpeechSynthesisVoice) -> Void) {
        self.selectedVoice = selectedVoice
        self.availableVoices = availableVoices
        self.updateSelectedVoice = updateSelectedVoice

        try? Tips.configure([.displayFrequency(.monthly)])
    }

    var body: some View {
        List {
            TipView(additionalVoiceDownloadTip)
                .tipBackground(Color(.secondarySystemGroupedBackground))
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

            ForEach(AVSpeechSynthesisVoiceGender.allCases) { gender in
                let voices = availableVoices.filter { $0.gender == gender }
                if !voices.isEmpty {
                    Section(gender.name) {
                        ForEach(voices) { voice in
                            Button {
                                updateSelectedVoice(voice)
                                dismiss()
                            } label: {
                                Label {
                                    LabeledContent {
                                        if let selectedVoice,
                                           voice == selectedVoice {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(Color.accentColor)
                                        }
                                    } label: {
                                        Text(voice.name)
                                            .foregroundStyle(Color.primary)
                                    }
                                } icon: {
                                    Button {
                                        // TODO: Play sample audio.
                                        print("play sample")
                                    } label: {
                                        Image(systemName: "play.circle")
                                    }
                                    .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Voice", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    VoiceSelectionView(selectedVoice: .init(language: "en-US")!,
                       availableVoices: AVSpeechSynthesisVoice.speechVoices()) { _ in }
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
