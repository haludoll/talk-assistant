//
//  ConversationiView.swift
//  Conversation
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI
import SpeechSynthesizer

public struct ConversationView: View {
    @State private var speechSynthesizer = SpeechSynthesizer()
    public init() {}

    public var body: some View {
        PhraseTextField(text: $speechSynthesizer.text, isSpeaking: speechSynthesizer.isSpeaking)
            .onSubmit { text in
                speechSynthesizer.speak(text)
            }
            .shadow(radius: 4)
            .padding()
    }
}

#Preview {
    ConversationView()
}
