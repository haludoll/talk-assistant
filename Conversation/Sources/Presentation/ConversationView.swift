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
    @State private var showingPhraseCategoryCreateView = false
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
        .onAppear {
            conversationViewModel.setupVoice()
        }
        .task {
            await conversationViewModel.observeSpeechDelegate()
        }
        .toolbar {
            ToolbarItem {
                Button("", systemImage: "folder.badge.plus") {
                    showingPhraseCategoryCreateView.toggle()
                }
            }
        }
        .sheet(isPresented: $showingPhraseCategoryCreateView) {
            PhraseCategoryCreateView()
        }
    }
}

#Preview {
    NavigationStack {
        ConversationView()
    }
}
