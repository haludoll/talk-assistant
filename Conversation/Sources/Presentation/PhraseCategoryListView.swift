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
    @State private var phraseCategoryViewModel = PhraseCategoryViewModel()
    //@State private var navigateToCategoryDetailView: PhraseCategory?
    @State private var showingPhraseCategoryCreateView = false
    @State private var showingDeleteAlert = false
    @State private var deletingPhraseCategory: PhraseCategory?

    var body: some View {
        List {
            ForEach(phraseCategoryViewModel.phraseCategories) { phraseCategory in
                NavigationLink {
                    PhraseCategoryDetailView(phraseCategory: phraseCategory)
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
//        .navigationDestination(item: $navigateToCategoryDetailView) { phraseCategory in
//
//        }
        .sheet(isPresented: $showingPhraseCategoryCreateView, onDismiss: {
            phraseCategoryViewModel.fetchAll()
        }) {
            PhraseCategoryCreateView()
        }
        .alert(String(localized: "Delete Category \"\(deletingPhraseCategory?.metadata.name ?? "")\"?", bundle: .module), isPresented: $showingDeleteAlert, presenting: deletingPhraseCategory) { phraseCategoryToDelete in
            Button(String(localized: "Delete", bundle: .module), role: .destructive) {
                withAnimation {
                    phraseCategoryViewModel.delete(phraseCategoryToDelete)
                }
            }
        } message: { _ in
            Text("This will delete all phrases in this category.", bundle: .module)
        }
        .task {
            phraseCategoryViewModel.fetchAll()
        }
    }
}

#Preview {
    NavigationStack {
        PhraseCategoryListView()
    }
}
