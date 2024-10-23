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
    @FocusState private var phraseTextFieldFocused: Bool

    public init() {}

    public var body: some View {
        VStack {
            Spacer()

            PhraseTextField(text: $speechSynthesizer.text,
                            isSpeaking: speechSynthesizer.isSpeaking,
                            focused: $phraseTextFieldFocused,
                            playButtonTapped: { speechSynthesizer.speak(speechSynthesizer.text) },
                            stopButtonTapped: { speechSynthesizer.stop() })
            .onSubmit { text in
                speechSynthesizer.speak(text)
            }
            .shadow(radius: 4)
            .padding()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            phraseTextFieldFocused = false
        }
    }
}

#Preview {
    ConversationView()
}
