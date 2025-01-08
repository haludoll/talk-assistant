//
//  PhraseCategoryListHeader.swift
//  Conversation
//
//  Created by haludoll on 2024/12/16.
//
import SwiftUI
import ConversationEntity

struct PhraseCategoryListHeader: View {
    let phraseCategories: [PhraseCategory]
    @Binding var selectedPhraseCategory: PhraseCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(phraseCategories) { phraseCategory in
                    Button {
                        self.selectedPhraseCategory = phraseCategory
                    } label: {
                        Label {
                            Text(phraseCategory.metadata.name)
                                .foregroundStyle(phraseCategory == selectedPhraseCategory ? Color.primary : Color(.secondaryLabel))
                                .bold()
                        } icon: {
                            Image(systemName: phraseCategory.metadata.icon.name)
                                .foregroundStyle(phraseCategory.metadata.icon.color)
                        }
                        .font(.subheadline)
                        .labelStyle(.phraseCategoryLabel)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(phraseCategory == selectedPhraseCategory ? Color(.secondarySystemGroupedBackground) : Color(.systemGroupedBackground))
                        .cornerRadius(4)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGroupedBackground))
    }
}

private struct PhraseCategoryLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
            configuration.title
        }
    }
}

private extension LabelStyle where Self == PhraseCategoryLabelStyle {
    static var phraseCategoryLabel: Self { Self() }
}

#Preview {
    @Previewable @State var selectedCategory: PhraseCategory? = .init(id: .init(0), createdAt: .now, metadata: .init(name: "home", icon: .init(name: "house.fill", color: .blue)), phrases: [])
    let phraseCategories: [PhraseCategory] = [selectedCategory!, .init(id: .init(2), createdAt: .now, metadata: .init(name: "Health", icon: .init(name: "heart.fill", color: .pink)), phrases: [])]
    PhraseCategoryListHeader(phraseCategories: phraseCategories, selectedPhraseCategory: $selectedCategory)
}
