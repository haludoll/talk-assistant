//
//  RepeatButton.swift
//  Conversation
//
//  Created by haludoll on 2024/10/23.
//

import SwiftUI

struct RepeatButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "arrow.uturn.backward")
        }
        .repeatButtonStyle()
    }
}

private extension View {
    @ViewBuilder
    func repeatButtonStyle() -> some View {
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
    RepeatButton() {}
}
