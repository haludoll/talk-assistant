//
//  ConversationiView.swift
//  Conversation
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI
import ConversationViewModel
import ConversationEntity

public struct ConversationView: View {
    @State private var typeToSpeakViewModel = TypeToSpeakViewModel()
    @State private var phraseCategorySpeakViewModel = PhraseCategorySpeakViewModel()
    @FocusState private var phraseTextFieldFocused: Bool

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading) {
                    PhraseCategoryListHeader(phraseCategories: phraseCategorySpeakViewModel.phraseCategories,
                                             selectedPhraseCategory: .init(get: { phraseCategorySpeakViewModel.selectedPhraseCategory },
                                                                           set: { phraseCategorySpeakViewModel.selectedPhraseCategory = $0 }))

                    Divider()
                        .padding(.horizontal)

                    VStack(spacing: 8) {
                        if let selectedPhraseCategory = phraseCategorySpeakViewModel.selectedPhraseCategory {
                            ForEach(selectedPhraseCategory.phrases) { phrase in
                                Button {

                                } label: {
                                    Text(phrase.value)
                                        .foregroundStyle(Color.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(Color(.secondarySystemBackground))
                                        .cornerRadius(8)
                                }
                            }

                            Color(.systemBackground)
                                .frame(height: 140)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 2)

                    Spacer()
                }
            }
            .blurNavigationBar()

            VStack(alignment: .trailing, spacing: 4) {
                RepeatButton {
                    typeToSpeakViewModel.text = typeToSpeakViewModel.lastText
                    typeToSpeakViewModel.speak()
                }
                .disabled(typeToSpeakViewModel.lastText.isEmpty)

                PhraseTextField(typeToSpeakViewModel: typeToSpeakViewModel, focused: $phraseTextFieldFocused)
            }
            .padding()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            phraseTextFieldFocused = false
        }
        .onAppear {
            typeToSpeakViewModel.setupVoice()
            phraseCategorySpeakViewModel.fetchPhraseCategories()
        }
        .task {
            await typeToSpeakViewModel.observeSpeechDelegate()
        }
    }
}

#Preview {
    NavigationStack {
        ConversationView()
    }
}
