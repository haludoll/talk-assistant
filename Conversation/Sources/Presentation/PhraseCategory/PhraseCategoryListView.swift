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
    @State private var phraseCategoryListViewModel = PhraseCategoryListViewModel()
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
                        LabeledContent(phraseCategory.name, value: "\(phraseCategory.phrases.count)")
                    } icon: {
                        Image(systemName: phraseCategory.icon.systemName)
                            .foregroundStyle(phraseCategory.icon.color.toColor())
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
            .onMove { indices, newOffset in
                phraseCategoryListViewModel.moveCategory(from: indices, to: newOffset)
            }
            .onDelete { _ in
                // WORKAROUND: .swipeActionの方に処理が流れてしまうので、ここでは何もしない
            }
        }
        .navigationTitle(Text("Category List", bundle: .module))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("", systemImage: "folder.badge.plus") {
                    showingPhraseCategoryCreateView.toggle()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $showingPhraseCategoryCreateView, onDismiss: {
            phraseCategoryListViewModel.fetchAll()
        }) {
            PhraseCategoryCreateView()
        }
        .alert(String(localized: "Delete Category \"\(deletingPhraseCategory?.name ?? "")\"?", bundle: .module), isPresented: $showingDeleteAlert, presenting: deletingPhraseCategory) { phraseCategoryToDelete in
            Button(String(localized: "Delete", bundle: .module), role: .destructive) {
                withAnimation {
                    phraseCategoryDeleteViewModel.delete(phraseCategoryToDelete)
                    phraseCategoryListViewModel.fetchAll()
                }
            }
        } message: { _ in
            Text("This will delete all phrases in this category.", bundle: .module)
        }
        .onAppear {
            phraseCategoryListViewModel.fetchAll()
        }
    }
}

#Preview {
    NavigationStack {
        PhraseCategoryListView()
    }
}
