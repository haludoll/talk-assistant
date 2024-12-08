//
//  PhraseAddView.swift
//  Conversation
//
//  Created by haludoll on 2024/12/08.
//

import SwiftUI
import ConversationEntity
import ConversationViewModel

struct PhraseAddView: View {
    @State private var text = ""
    @State private var phraseAddViewModel = PhraseAddViewModel()
    @FocusState private var focused: Bool
    @Environment(\.dismiss) private var dismiss

    let phraseCategory: PhraseCategory

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(String(localized: "Enter phrase", bundle: .module), text: $text, axis: .vertical)
                        .focused($focused)
                }
            }
            .navigationTitle(Text("Add Phrase", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save", bundle: .module)) {
                        phraseAddViewModel.add(text, to: phraseCategory)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel", bundle: .module)) {
                        dismiss()
                    }
                }
            }
            .onTapGesture {
                focused = false
            }
        }
        .onAppear {
            focused = true
        }
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true)) {
            PhraseAddView(phraseCategory: .init(id: .init(), sortOrder: 0, metadata: .init(name: "home", icon: .init(name: "house.fill", color: .blue)), phrases: []))
        }
}
