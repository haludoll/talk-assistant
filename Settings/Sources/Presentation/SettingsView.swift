//
//  SettingsView.swift
//  Settings
//
//  Created by haludoll on 2024/10/23.
//

import SwiftUI
import SettingsViewModel
import LicenseList
import enum AVFoundation.AVSpeechSynthesisVoiceGender

public struct SettingsView: View {
    @State private var voiceSettingsViewModel = VoiceSettingsViewModel()
    @State private var speechSampleViewModel = SpeechSampleViewModel()
    @State private var isSkipped = false
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

                Section {
                    Link(destination: URL(string: String(localized: "https://haludoll.github.io/talk-assistant/terms-of-use-en.html", bundle: .module))!) {
                        Label(String(localized: "Terms of Use", bundle: .module), systemImage: "safari")
                    }
                    Link(destination: URL(string: String(localized: "https://haludoll.github.io/talk-assistant/privacy-policy-en.html", bundle: .module))!) {
                        Label(String(localized: "Privacy Policy", bundle: .module), systemImage: "safari")
                    }
                    NavigationLink(String(localized: "Licenses", bundle: .module)) {
                        LicenseListView()
                            .licenseViewStyle(.withRepositoryAnchorLink)
                            .navigationTitle(Text("Open source Licenses", bundle: .module))
                    }
                }
                .foregroundStyle(Color.primary)
            }
            .navigationTitle(Text("Settings", bundle: .module))
            .task {
                voiceSettingsViewModel.fetchVoiceParameter()
                voiceSettingsViewModel.fetchAvailableVoices()
                voiceSettingsViewModel.fetchSelectedVoice()
                await speechSampleViewModel.observeSpeechDelegate()
            }
            .onChange(of: [voiceSettingsViewModel.rate,
                           voiceSettingsViewModel.pitchMultiplier,
                           voiceSettingsViewModel.volume]) { _, _ in
                if isSkipped {
                    voiceSettingsViewModel.updateVoiceParam()
                    if let voice = voiceSettingsViewModel.selectedVoice {
                        speechSampleViewModel.stopSampleText(with: voice)
                        speechSampleViewModel.speakSample(text: String(localized: "This is a sample sentence.", bundle: .module),
                                                          with: voice,
                                                          using: voiceSettingsViewModel.voiceParameter)
                    }
                }
                isSkipped = true
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
