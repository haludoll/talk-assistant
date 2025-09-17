//
//  PhraseCategoryDetailView.swift
//  Conversation
//
//  Created by haludoll on 2024/12/07.
//

import SwiftUI
import ConversationViewModel
import ConversationEntity

struct PhraseCategoryDetailView: View {
    @State private var phraseCategoryDetailViewModel = PhraseCategoryDetailViewModel()
    @State private var phraseCategoryDeleteViewModel = PhraseCategoryDeleteViewModel()
    @State private var phraseDeleteViewModel = PhraseDeleteViewModel()
    @Environment(\.dismiss) private var dismiss

    @State private var showingPhraseCategoryEditView = false
    @State private var showingPhraseAddView = false
    @State private var showingDeleteAlert = false
    @State private var deletingPhraseCategory: PhraseCategory?

    private let phraseCategoryID: PhraseCategory.ID

    init(phraseCategoryID: PhraseCategory.ID) {
        self.phraseCategoryID = phraseCategoryID
    }

    var body: some View {
        VStack {
            if let phraseCategory = phraseCategoryDetailViewModel.phraseCategory {
                Form {
                    Section {
                        Button {
                            showingPhraseCategoryEditView.toggle()
                        } label: {
                            VStack {
                                Image(systemName: phraseCategory.icon.systemName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(phraseCategory.icon.color.toColor())

                                Text(phraseCategory.name)
                                    .font(.title2)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color.primary)

                                Text("Edit", bundle: .module)
                                    .foregroundStyle(Color.accentColor)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .listRowInsets(.init())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                    Section {
                        Button(String(localized: "Add New Phrase", bundle: .module)) {
                            showingPhraseAddView.toggle()
                        }
                    }

                    if !phraseCategory.phrases.isEmpty {
                        Section {
                            ForEach(phraseCategory.phrases) { phrase in
                        Text(phrase.value)
                                    .swipeActions {
                                        Button(String(localized: "Delete", bundle: .module)) {
                                            withAnimation  {
                                                phraseDeleteViewModel.delete(phrase.id, in: phraseCategoryID)
                                                phraseCategoryDetailViewModel.fetch(for: phraseCategoryID)
                                            }
                                        }
                                        .tint(.red)
                                    }
                            }
                        } header: {
                            Text("phrases", bundle: .module)
                        }
                    }

                    Section {
                        Button(String(localized: "Delete Category", bundle: .module), role: .destructive) {
                            deletingPhraseCategory = phraseCategory
                            showingDeleteAlert.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showingPhraseCategoryEditView, onDismiss: {
                    phraseCategoryDetailViewModel.fetch(for: phraseCategoryID)
                }) {
                    PhraseCategoryEditView(phraseCategory: phraseCategory)
                }
                .sheet(isPresented: $showingPhraseAddView, onDismiss: {
                    phraseCategoryDetailViewModel.fetch(for: phraseCategoryID)
                }) {
                    PhraseAddView(phraseCategoryID: phraseCategoryID)
                }
                .alert(String(localized: "Delete Category \"\(deletingPhraseCategory?.name ?? "")\"?", bundle: .module), isPresented: $showingDeleteAlert, presenting: deletingPhraseCategory) { phraseCategoryToDelete in
                    Button(String(localized: "Delete", bundle: .module), role: .destructive) {
                        withAnimation {
                            phraseCategoryDeleteViewModel.delete(phraseCategoryToDelete)
                            dismiss()
                        }
                    }
                } message: { _ in
                    Text("This will delete all phrases in this category.", bundle: .module)
                }
            }
        }
        .task {
            phraseCategoryDetailViewModel.fetch(for: phraseCategoryID)
        }
    }
}

#Preview {
    NavigationStack {
        PhraseCategoryDetailView(phraseCategoryID: .init(0))
    }
}
