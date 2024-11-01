//
//  VoiceSelectionView.swift
//  Settings
//
//  Created by haludoll on 2024/10/24.
//

import SwiftUI
import class AVFoundation.AVSpeechSynthesisVoice

struct VoiceSelectionView: View {
    let availableVoices: [AVSpeechSynthesisVoice]

    var body: some View {
        List {
            Text("Additional voices can be downloaded from the device Settings app > Accessibility > Spoken Content > Voices.\nReopen this screen again after the download is complete.", bundle: .module)
                .foregroundStyle(.secondary)
                .listRowBackground(Color.clear)

            Section(String(localized: "Male", bundle: .module)) {
                ForEach(availableVoices.filter { $0.gender == .male }, id: \.self) { voice in
                    Text(voice.name)
                }
            }

            Section(String(localized: "Female", bundle: .module)) {
                ForEach(availableVoices.filter { $0.gender == .female }, id: \.self) { voice in
                    Text(voice.name)
                }
            }

            Section(String(localized: "Others", bundle: .module)) {
                ForEach(availableVoices.filter { $0.gender == .unspecified }, id: \.self) { voice in
                    Text(voice.name)
                }
            }
        }
        .navigationTitle(Text("Voice", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    VoiceSelectionView(availableVoices: AVSpeechSynthesisVoice.speechVoices())
}
