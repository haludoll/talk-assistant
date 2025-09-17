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
                            Text(phraseCategory.name)
                                .foregroundStyle(phraseCategory == selectedPhraseCategory ? Color.primary : Color(.secondaryLabel))
                                .bold()
                        } icon: {
                            Image(systemName: phraseCategory.icon.systemName)
                                .foregroundStyle(phraseCategory.icon.color.toColor())
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
    @Previewable @State var selectedCategory: PhraseCategory? = .init(
        id: .init(0),
        createdAt: .now,
        name: "home",
        icon: .init(systemName: "house.fill", color: .init(red: 0.0, green: 0.478, blue: 1.0)),
        phrases: []
    )
    let phraseCategories: [PhraseCategory] = [
        selectedCategory!,
        .init(id: .init(2), createdAt: .now, name: "Health", icon: .init(systemName: "heart.fill", color: .init(red: 1.0, green: 0.2, blue: 0.5)), phrases: [])
    ]
    PhraseCategoryListHeader(phraseCategories: phraseCategories, selectedPhraseCategory: $selectedCategory)
}
