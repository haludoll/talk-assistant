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
        VStack(alignment: .leading) {
            PhraseCategoryListHeader()

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                RepeatButton {
                    conversationViewModel.text = conversationViewModel.lastText
                    conversationViewModel.speak()
                }
                .disabled(conversationViewModel.lastText.isEmpty)

                PhraseTextField(conversationViewModel: conversationViewModel, focused: $phraseTextFieldFocused)
            }
        }
        .contentShape(Rectangle())
        .padding()
        .onTapGesture {
            phraseTextFieldFocused = false
        }
        .onAppear {
            conversationViewModel.setupVoice()
        }
        .task {
            await conversationViewModel.observeSpeechDelegate()
        }
    }
}

private struct PhraseCategoryListHeader: View {
    @State private var showingPhraseCategoryListView = false

    var body: some View {
        VStack {
            Button {
                showingPhraseCategoryListView.toggle()
            } label: {
                HStack {
                    Text("Category", bundle: .module)
                        .font(.title2)

                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
        .navigationDestination(isPresented: $showingPhraseCategoryListView) {
            PhraseCategoryListView()
        }
    }
}

#Preview {
    NavigationStack {
        ConversationView()
    }
}
