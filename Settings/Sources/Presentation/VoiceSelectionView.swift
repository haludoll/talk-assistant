//
//  VoiceSelectionView.swift
//  Settings
//
//  Created by haludoll on 2024/10/24.
//

import SwiftUI
import SettingsViewModel
import AVFoundation

struct VoiceSelectionView: View {
    @Binding var selectedVoice: AVSpeechSynthesisVoice?
    let availableVoices: [AVSpeechSynthesisVoice]

    var body: some View {
        List {
            AnyView(
                Text(Image(systemName: "info.circle")).foregroundStyle(.secondary)
                    + Text(" ")
                    + Text("Additional voices can be downloaded from the device Settings app > Accessibility > Spoken Content > Voices.\nOpen this screen again after the download is complete.", bundle: .module).foregroundStyle(.secondary)
            )
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .padding(.horizontal)

            ForEach(AVSpeechSynthesisVoiceGender.allCases) { gender in
                let voices = availableVoices.filter { $0.gender == gender }
                if !voices.isEmpty {
                    Section(gender.name) {
                        ForEach(voices) { voice in
                            Button {
                                print("row")
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
    VoiceSelectionView(selectedVoice: .constant(.init(language: "en-US")!),
                       availableVoices: AVSpeechSynthesisVoice.speechVoices())
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
