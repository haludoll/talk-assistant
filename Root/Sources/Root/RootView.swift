//
//  RootView.swift
//  Root
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI
import ConversationPresentation

public struct RootView: View {
    public init() {}
    public var body: some View {
        NavigationStack {
            ConversationView()
                .navigationTitle(Text("Talk Assistant", bundle: .module))
        }
    }
}

#Preview {
    RootView()
}
