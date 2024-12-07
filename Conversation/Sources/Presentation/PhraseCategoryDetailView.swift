//
//  PhraseCategoryDetailView.swift
//  Conversation
//
//  Created by haludoll on 2024/12/07.
//

import SwiftUI
import ConversationEntity

struct PhraseCategoryDetailView: View {
    let phraseCategory: PhraseCategory

    @State private var showingPhraseCategoryEditView = false

    var body: some View {
        Form {
            Section {
                Button {
                    showingPhraseCategoryEditView.toggle()
                } label: {
                    VStack {
                        Image(systemName: phraseCategory.metadata.icon.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(phraseCategory.metadata.icon.color)

                        Text(phraseCategory.metadata.name)
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


            Button(String(localized: "Delete Category", bundle: .module), role: .destructive) {

            }
        }
        .sheet(isPresented: $showingPhraseCategoryEditView) {
            PhraseCategoryEditView(phraseCategory: phraseCategory)
        }
    }
}

#Preview {
    NavigationStack {
        PhraseCategoryDetailView(phraseCategory: .init(id: .init(), metadata: .init(name: "Home", icon: .init(name: "house.fill", color: .blue)), phrases: []))
    }
}
