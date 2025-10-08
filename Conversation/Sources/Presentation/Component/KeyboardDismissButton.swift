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
        .keyboardDismissButtonStyle()
    }
}

private extension View {
    @ViewBuilder
    func keyboardDismissButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            self.font(.title2)
                .padding(8)
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive())
        } else {
            self.buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                .background(Color(.systemBackground))
                .clipShape(Circle())
        }
    }
}

#Preview {
    KeyboardDismissButton() {}
}
