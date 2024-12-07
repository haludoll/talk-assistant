//
//  PhraseCategoryListView.swift
//  Conversation
//
//  Created by haludoll on 2024/12/06.
//

import SwiftUI
import ConversationViewModel
import ConversationEntity

struct PhraseCategoryListView: View {
    @StateObject private var phraseCategoryListViewModel = PhraseCategoryListViewModel()
    @State private var phraseCategoryDeleteViewModel = PhraseCategoryDeleteViewModel()
    @State private var showingPhraseCategoryCreateView = false
    @State private var showingDeleteAlert = false
    @State private var deletingPhraseCategory: PhraseCategory?

    var body: some View {
        List {
            ForEach(phraseCategoryListViewModel.phraseCategories) { phraseCategory in
                NavigationLink {
                    PhraseCategoryDetailView(phraseCategoryID: phraseCategory.id)
                } label: {
                    Label {
                        Text(phraseCategory.metadata.name)
                    } icon: {
                        Image(systemName: phraseCategory.metadata.icon.name)
                            .foregroundStyle(phraseCategory.metadata.icon.color)
                    }
                    .swipeActions {
                        Button(String(localized: "Delete", bundle: .module)) {
                            deletingPhraseCategory = phraseCategory
                            showingDeleteAlert.toggle()
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .navigationTitle(Text("Category List", bundle: .module))
        .toolbar {
            ToolbarItem {
                Button("", systemImage: "folder.badge.plus") {
                    showingPhraseCategoryCreateView.toggle()
                }
            }
        }
        .sheet(isPresented: $showingPhraseCategoryCreateView, onDismiss: {
            phraseCategoryListViewModel.fetchAll()
        }) {
            PhraseCategoryCreateView()
        }
        .alert(String(localized: "Delete Category \"\(deletingPhraseCategory?.metadata.name ?? "")\"?", bundle: .module), isPresented: $showingDeleteAlert, presenting: deletingPhraseCategory) { phraseCategoryToDelete in
            Button(String(localized: "Delete", bundle: .module), role: .destructive) {
                withAnimation {
                    phraseCategoryDeleteViewModel.delete(phraseCategoryToDelete)
                    phraseCategoryListViewModel.fetchAll()
                }
            }
        } message: { _ in
            Text("This will delete all phrases in this category.", bundle: .module)
        }
        .task {
            phraseCategoryListViewModel.fetchAll()
        }
    }
}

#Preview {
    NavigationStack {
        PhraseCategoryListView()
    }
}
