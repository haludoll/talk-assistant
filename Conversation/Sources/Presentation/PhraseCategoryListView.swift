//
//  PhraseCategoryListView.swift
//  Conversation
//
//  Created by haludoll on 2024/12/06.
//

import SwiftUI
import ConversationViewModel

struct PhraseCategoryListView: View {
    @State private var phraseCategoryViewModel = PhraseCategoryViewModel()
    @State private var showingPhraseCategoryCreateView = false

    var body: some View {
        List {
            ForEach(phraseCategoryViewModel.phraseCategories) { phraseCategory in
                Label {
                    Text(phraseCategory.metadata.name)
                } icon: {
                    Image(systemName: phraseCategory.metadata.icon.name)
                        .foregroundStyle(phraseCategory.metadata.icon.color)
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
            phraseCategoryViewModel.fetchAll()
        }) {
            PhraseCategoryCreateView()
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
