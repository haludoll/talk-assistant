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

private struct PhraseCategoryListHeader: View {
    var body: some View {
        VStack {
            Button {
                // TODO: Destinate to ListView
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
    }
}

#Preview {
    NavigationStack {
        ConversationView()
    }
}
