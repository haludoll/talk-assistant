//
//  ConversationiView.swift
//  Conversation
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI
import ConversationEntity
import ConversationViewModel
import ViewExtensions

public struct ConversationView: View {
    @State private var phraseSpeakViewModel = PhraseSpeakViewModel()
    @State private var phraseCategorySpeakViewModel = PhraseCategorySpeakViewModel()
    @FocusState private var phraseTextFieldFocused: Bool
    @Namespace private var speechInputAccessoryViewUnionNamespace

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    PhraseCategoryHeaderTitle()

                    PhraseCategoryListHeader(phraseCategories: phraseCategorySpeakViewModel.phraseCategories,
                                             selectedPhraseCategory: .init(get: { phraseCategorySpeakViewModel.selectedPhraseCategory },
                                                                           set: {  phraseCategorySpeakViewModel.selectedPhraseCategory = $0 }))

                    PhrasesPageView(selectedPhraseCategory: phraseCategorySpeakViewModel.selectedPhraseCategory,
                                    phraseSpeakViewModel: phraseSpeakViewModel)
                }
            }
            .padding(.bottom)
            .onTapGesture {
                phraseTextFieldFocused = false
            }

            VStack(alignment: .trailing, spacing: 4) {
                SpeechInputAccessoryView()

                PhraseTextField(phraseSpeakViewModel: phraseSpeakViewModel, focused: $phraseTextFieldFocused)
            }
            .padding()
            .blurNavigationBar()
        }
        .background(Color(.systemGroupedBackground))
        .contentShape(.rect)
        .task {
            phraseSpeakViewModel.setupVoice()
            await phraseCategorySpeakViewModel.createDefault()
            await phraseCategorySpeakViewModel.fetchAll()
        }
        .sceneCancellableTask {
            await phraseSpeakViewModel.observeSpeechDelegate()
        }
    }

    @ViewBuilder
    func SpeechInputAccessoryView() -> some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                HStack(spacing: 8) {
                    repeatButton()
                        .glassEffectUnion(id: "speechInputAccessory", namespace: speechInputAccessoryViewUnionNamespace)

                    keyboardDismissButton()
                        .glassEffectUnion(id: "speechInputAccessory", namespace: speechInputAccessoryViewUnionNamespace)
                }
            }
            .contentShape(.rect)    // NOTE: To prevent tap events from being captured by the background phrase list
        } else {
            HStack(spacing: 0) {
                repeatButton()
                keyboardDismissButton()
            }
        }
    }

    @ViewBuilder
    private func repeatButton() -> some View {
        RepeatButton {
            phraseSpeakViewModel.text = phraseSpeakViewModel.lastText
            phraseSpeakViewModel.speak()
        }
        .disabled(phraseSpeakViewModel.lastText.isEmpty)
    }

    @ViewBuilder
    private func keyboardDismissButton() -> some View {
        KeyboardDismissButton {
            phraseTextFieldFocused = false
        }
        .disabled(!phraseTextFieldFocused)
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

    private var phrases: [PhraseCategory.Phrase] {
        guard let selectedPhraseCategory else { return [] }
        return selectedPhraseCategory.phrases
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(phrases) { phrase in
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

                        if let lastID = phrases.last?.id,
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
