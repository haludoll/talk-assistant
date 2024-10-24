//
//  SettingsView.swift
//  Settings
//
//  Created by haludoll on 2024/10/23.
//

import SwiftUI
import SettingsViewModel

public struct SettingsView: View {
    @State private var settingViewModel = SettingsViewModel()
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(String(localized: "Use System Voice Setting", bundle: .module), isOn: $settingViewModel.prefersAssistiveTechnologySettings)

                } footer: {
                    Text("When enabled, the voice set in Settings > Accessibility > Spoken Content will be applied", bundle: .module)
                }

                if !settingViewModel.prefersAssistiveTechnologySettings {
                    Section(String(localized: "Rate", bundle: .module)) {
                        Slider(value: $settingViewModel.rate,
                               in: SettingsViewModel.rateRange,
                               step: 0.1) {
                        } minimumValueLabel: {
                            Image(systemName: "tortoise.fill")
                        } maximumValueLabel: {
                            Image(systemName: "hare.fill")
                        }
                        .foregroundStyle(Color(.secondaryLabel))
                    }

                    Section(String(localized: "Pitch", bundle: .module)) {
                        Slider(value: $settingViewModel.pitchMultiplier,
                               in: SettingsViewModel.pitchRange,
                               step: 0.1) {
                        } minimumValueLabel: {
                            Image(systemName: "waveform.badge.minus")
                        } maximumValueLabel: {
                            Image(systemName: "waveform.badge.plus")
                        }
                        .foregroundStyle(Color(.secondaryLabel))
                    }

                    Section(String(localized: "Volume", bundle: .module)) {
                        Slider(value: $settingViewModel.volume,
                               in: SettingsViewModel.volumeRange,
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
                settingViewModel.fetchVoiceParameter()
            }
        }
    }
}

#Preview {
    SettingsView()
}
