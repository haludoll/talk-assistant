//
//  SettingsView.swift
//  Settings
//
//  Created by haludoll on 2024/10/23.
//

import SwiftUI
import SettingsViewModel
import enum AVFoundation.AVSpeechSynthesisVoiceGender

public struct SettingsView: View {
    @State private var voiceSettingsViewModel = VoiceSettingsViewModel()
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(String(localized: "Use System Voice Setting", bundle: .module), isOn: $voiceSettingsViewModel.prefersAssistiveTechnologySettings)
                } footer: {
                    Text("When enabled, the voice set in the device Settings app > Accessibility > Spoken Content will be applied", bundle: .module)
                }

                if !voiceSettingsViewModel.prefersAssistiveTechnologySettings {
                    NavigationLink {
                        VoiceSelectionView(voiceSettingsViewModel: voiceSettingsViewModel)
                    } label: {
                        LabeledContent(String(localized: "Voice", bundle: .module), value: voiceSettingsViewModel.selectedVoice?.name ?? "")
                    }

                    Section(String(localized: "Rate", bundle: .module)) {
                        Slider(value: $voiceSettingsViewModel.rate,
                               in: VoiceSettingsViewModel.rateRange,
                               step: 0.1) {
                        } minimumValueLabel: {
                            Image(systemName: "tortoise.fill")
                        } maximumValueLabel: {
                            Image(systemName: "hare.fill")
                        }
                        .foregroundStyle(Color(.secondaryLabel))
                    }

                    Section(String(localized: "Pitch", bundle: .module)) {
                        Slider(value: $voiceSettingsViewModel.pitchMultiplier,
                               in: VoiceSettingsViewModel.pitchRange,
                               step: 0.1) {
                        } minimumValueLabel: {
                            Image(systemName: "waveform.badge.minus")
                        } maximumValueLabel: {
                            Image(systemName: "waveform.badge.plus")
                        }
                        .foregroundStyle(Color(.secondaryLabel))
                    }

                    Section(String(localized: "Volume", bundle: .module)) {
                        Slider(value: $voiceSettingsViewModel.volume,
                               in: VoiceSettingsViewModel.volumeRange,
                               step: 0.1) {
                        } minimumValueLabel: {
                            Image(systemName: "speaker.fill")
                        } maximumValueLabel: {
                            Image(systemName: "speaker.wave.3.fill")
                        }
                        .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }
            .navigationTitle(Text("Settings", bundle: .module))
            .task {
                voiceSettingsViewModel.fetchVoiceParameter()
                voiceSettingsViewModel.fetchAvailableVoices()
                voiceSettingsViewModel.fetchSelectedVoice()
            }
            .onChange(of: [voiceSettingsViewModel.rate,
                           voiceSettingsViewModel.pitchMultiplier,
                           voiceSettingsViewModel.volume]) { _, _ in
                voiceSettingsViewModel.updateVoiceParam()
            }
            .onChange(of: voiceSettingsViewModel.prefersAssistiveTechnologySettings) { _, _ in
                voiceSettingsViewModel.updateVoiceParam()
            }
        }
    }
}

#Preview {
    SettingsView()
}
