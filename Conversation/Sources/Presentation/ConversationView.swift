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

            VStack(alignment: .trailing, spacing: 4) {
                RepeatButton {
                    speechSynthesizer.text = speechSynthesizer.lastText
                    speechSynthesizer.speak()
                }
                .disabled(speechSynthesizer.lastText.isEmpty)

                PhraseTextField(text: $speechSynthesizer.text,
                                isSpeaking: speechSynthesizer.isSpeaking,
                                focused: $phraseTextFieldFocused,
                                playButtonTapped: { speechSynthesizer.speak() },
                                stopButtonTapped: { speechSynthesizer.stop() })
                .onSubmit { _ in
                    speechSynthesizer.speak()
                }
            }
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
