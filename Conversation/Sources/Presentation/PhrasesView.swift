//
//  PhrasesView.swift
//  Conversation
//
//  Created by haludoll on 2025/01/06.
//

import SwiftUI
import ConversationEntity
import ConversationViewModel

struct PhrasesView: View {
    let selectedPhraseCategory: PhraseCategory?
    let typeToSpeakViewModel: TypeToSpeakViewModel

    var body: some View {
        VStack(spacing: 0) {
            if let selectedPhraseCategory {
                ForEach(selectedPhraseCategory.phrases) { phrase in
                    VStack(spacing: 0) {
                        Button {
                            typeToSpeakViewModel.text = phrase.value
                            typeToSpeakViewModel.speak()
                        } label: {
                            HStack {
                                Text(phrase.value)
                                    .foregroundStyle(Color.primary)
                            }
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
    }
}

#Preview {
    NavigationStack {
        ConversationView()
    }
}
