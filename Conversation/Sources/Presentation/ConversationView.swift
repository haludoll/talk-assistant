//
//  ConversationiView.swift
//  Conversation
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI
import ConversationViewModel
import ConversationEntity
import ViewExtensions

public struct ConversationView: View {
    @State private var phraseSpeakViewModel = PhraseSpeakViewModel()
    @State private var phraseCategorySpeakViewModel = PhraseCategorySpeakViewModel()
    @FocusState private var phraseTextFieldFocused: Bool

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    PhraseCategoryHeaderTitle()

                    LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                        Section {
                            PhrasesPageView(selectedPhraseCategory: phraseCategorySpeakViewModel.selectedPhraseCategory,
                                            phraseSpeakViewModel: phraseSpeakViewModel)
                        } header: {
                            PhraseCategoryListHeader(phraseCategories: phraseCategorySpeakViewModel.phraseCategories,
                                                     selectedPhraseCategory: .init(get: { phraseCategorySpeakViewModel.selectedPhraseCategory },
                                                                                   set: {  phraseCategorySpeakViewModel.selectedPhraseCategory = $0 }))
                        }
                    }
                }
            }
            .padding(.bottom)

            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 0) {
                    RepeatButton {
                        phraseSpeakViewModel.text = phraseSpeakViewModel.lastText
                        phraseSpeakViewModel.speak()
                    }
                    .disabled(phraseSpeakViewModel.lastText.isEmpty)

                    KeyboardDismissButton {
                        phraseTextFieldFocused = false
                    }
                    .disabled(!phraseTextFieldFocused)
                }

                PhraseTextField(phraseSpeakViewModel: phraseSpeakViewModel, focused: $phraseTextFieldFocused)
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
            phraseSpeakViewModel.setupVoice()
            phraseCategorySpeakViewModel.createDefault()
            phraseCategorySpeakViewModel.fetchAll()
        }
        .sceneCancellableTask {
            await phraseSpeakViewModel.observeSpeechDelegate()
        }
    }
}

private struct PhraseCategoryHeaderTitle: View {
    @State private var showingPhraseCategoryListView = false

    var body: some View {
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
        .padding(.horizontal)
        .navigationDestination(isPresented: $showingPhraseCategoryListView) {
            PhraseCategoryListView()
        }
    }
}

private struct PhrasesPageView: View {
    let selectedPhraseCategory: PhraseCategory?
    let phraseSpeakViewModel: PhraseSpeakViewModel
    
    private var sortedPhrases: [Phrase] {
        guard let selectedPhraseCategory else { return [] }
        return selectedPhraseCategory.phrases.sorted(by: { $0.createdAt > $1.createdAt })
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                // WORKAROUND: If you change the `phraseCategory` retrieved from SwiftData outside of View, there is a bug that for some reason the same data is retrieved more than once, so sort it here.
                ForEach(sortedPhrases) { phrase in
                    VStack(spacing: 0) {
                        Button {
                            phraseSpeakViewModel.stop()

                            if phrase.value != phraseSpeakViewModel.text || !phraseSpeakViewModel.isSpeaking {
                                phraseSpeakViewModel.text = phrase.value
                                phraseSpeakViewModel.speak()
                            }
                        } label: {
                            HStack {
                                Text(phrase.value)
                                    .foregroundStyle(Color.primary)
                                    .opacity(phraseSpeakViewModel.isSpeaking && phrase.value == phraseSpeakViewModel.text ? 0.3 : 1.0)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                        }

                        if let lastID = sortedPhrases.last?.id,
                           phrase.id != lastID {
                            Divider()
                                .padding(.leading)
                        }
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            Color(.systemGroupedBackground)
                .frame(height: 100)

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        ConversationView()
    }
}
