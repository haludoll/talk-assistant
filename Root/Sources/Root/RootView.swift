//
//  RootView.swift
//  Root
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI
import ConversationPresentation
import SettingsPresentation

public struct RootView: View {
    @State private var showingSettings = false

    public init() {}
    public var body: some View {
        NavigationStack {
            VStack {
                ConversationView()
                    .navigationTitle(Text("Talk Assistant", bundle: .module))
            }
            .toolbar {
                ToolbarItem {
                    Button("", systemImage: "gearshape") {
                        showingSettings.toggle()
                    }
                }
            }
            .navigationDestination(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    RootView()
}
