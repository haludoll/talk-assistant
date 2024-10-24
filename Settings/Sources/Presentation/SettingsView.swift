//
//  SettingsView.swift
//  Settings
//
//  Created by haludoll on 2024/10/23.
//

import SwiftUI

public struct SettingsView: View {
    @State private var takeOverOSSetting = false
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(String(localized: "Use System Voice Setting", bundle: .module), isOn: $takeOverOSSetting)

                } footer: {
                    Text("When enabled, the voice set in Settings > Accessibility > Spoken Content will be applied", bundle: .module)
                }

                if !takeOverOSSetting {
                    Text("hoge")
                }
            }
            .navigationTitle(Text("Settings", bundle: .module))
        }
    }
}

#Preview {
    SettingsView()
}
