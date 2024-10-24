//
//  SettingsView.swift
//  Settings
//
//  Created by haludoll on 2024/10/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var isPresentedPopover = false
    @State private var takeOverOSSetting = false

    var body: some View {
        NavigationStack {
            List {
                Section("Voice") {
                    Toggle(isOn: $takeOverOSSetting) {
                        HStack {
                            Text("Take over OS Settings")
                            Button {
                                
                                isPresentedPopover = true
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(Color(.secondaryLabel))
                            }
                            .popover(isPresented: $isPresentedPopover) {
                                Text("hoge")
                                    .presentationCompactAdaptation(PresentationAdaptation.popover)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Settings", bundle: .module))
        }
    }
}

#Preview {
    SettingsView()
}
