//
//  KeyboardDismissButton.swift
//  Conversation
//
//  Created by haludoll on 2025/01/10.
//

import SwiftUI

struct KeyboardDismissButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "keyboard.chevron.compact.down")
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .background(Color(.systemBackground))
        .clipShape(.circle)
    }
}

#Preview {
    KeyboardDismissButton() {}
}
