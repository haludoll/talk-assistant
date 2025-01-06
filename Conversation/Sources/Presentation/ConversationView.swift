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

                    VStack(spacing: 0) {
                        if let selectedPhraseCategory = phraseCategorySpeakViewModel.selectedPhraseCategory {
                            ForEach(selectedPhraseCategory.phrases) { phrase in
                                VStack(spacing: 0) {
                                    Button {

                                    } label: {
                                        Text(phrase.value)
                                            .foregroundStyle(Color.primary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal)
                                            .padding(.vertical, 12)
                                    }

                                    if let lastID = selectedPhraseCategory.phrases.last?.id,
                                       phrase.id != lastID {
                                        Divider()
                                            .padding(.leading)
                                    }
                                }

                            }
                        }
                    }
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.vertical, 2)

                    Color(.systemGroupedBackground)
                        .frame(height: 100)

                    Spacer()
                }
            }
            .padding(.bottom)

            VStack(alignment: .trailing, spacing: 4) {
                RepeatButton {
                    typeToSpeakViewModel.text = typeToSpeakViewModel.lastText
                    typeToSpeakViewModel.speak()
                }
                .disabled(typeToSpeakViewModel.lastText.isEmpty)

                PhraseTextField(typeToSpeakViewModel: typeToSpeakViewModel, focused: $phraseTextFieldFocused)
            }
            .padding()
            .blurNavigationBar()
        }
        .background(Color(.systemGroupedBackground))
        .contentShape(Rectangle())
        .onTapGesture {
            phraseTextFieldFocused = false
        }
        .onAppear {
            typeToSpeakViewModel.setupVoice()
            phraseCategorySpeakViewModel.fetchAll()
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
