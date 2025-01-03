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
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .background(Color(.systemBackground))
        .clipShape(.circle)
    }
}

#Preview {
    RepeatButton() {}
}
