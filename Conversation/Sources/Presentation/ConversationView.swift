//
//  ConversationiView.swift
//  Conversation
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI
import ConversationViewModel

public struct ConversationView: View {
    @State private var conversationViewModel = ConversationViewModel()
    @FocusState private var phraseTextFieldFocused: Bool

    public init() {}

    public var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                RepeatButton {
                    conversationViewModel.text = conversationViewModel.lastText
                    conversationViewModel.speak()
                }
                .disabled(conversationViewModel.lastText.isEmpty)

                PhraseTextField(text: $conversationViewModel.text,
                                isSpeaking: conversationViewModel.isSpeaking,
                                focused: $phraseTextFieldFocused,
                                playButtonTapped: { conversationViewModel.speak() },
                                stopButtonTapped: { conversationViewModel.stop() })
                .onSubmit { _ in
                    conversationViewModel.speak()
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
