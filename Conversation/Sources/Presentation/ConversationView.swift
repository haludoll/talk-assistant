//
//  ConversationiView.swift
//  Conversation
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI

public struct ConversationView: View {
    @State private var text = ""
    public init() {}

    public var body: some View {
        PhraseTextField(text: $text, isSpeaking: false)
            .shadow(radius: 4)
            .padding()
    }
}

#Preview {
    ConversationView()
        .environment(\.locale, .init(identifier: "ja"))
}
