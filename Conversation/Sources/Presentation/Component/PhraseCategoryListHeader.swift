//
//  PhraseCategoryListHeader.swift
//  Conversation
//
//  Created by haludoll on 2024/12/16.
//
import SwiftUI
import ConversationEntity

struct PhraseCategoryListHeader: View {
    @State private var showingPhraseCategoryListView = false
    let phraseCategories: [PhraseCategory]
    @Binding var selectedPhraseCategory: PhraseCategory?

    var body: some View {
        VStack {
            Button {
                showingPhraseCategoryListView.toggle()
            } label: {
                HStack {
                    Text("Category", bundle: .module)
                        .font(.title2)

                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(phraseCategories) { phraseCategory in
                        Button {
                            self.selectedPhraseCategory = phraseCategory
                        } label: {
                            Label {
                                Text(phraseCategory.metadata.name)
                                    .foregroundStyle(phraseCategory == selectedPhraseCategory ? Color.black : Color(.secondaryLabel))
                                    .bold()
                            } icon: {
                                Image(systemName: phraseCategory.metadata.icon.name)
                                    .foregroundStyle(phraseCategory.metadata.icon.color)
                            }
                            .font(.subheadline)
                            .labelStyle(.phraseCategoryLabel)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(phraseCategory == selectedPhraseCategory ? Color.white : Color(.secondarySystemBackground))
                            .cornerRadius(4)
                            .roundedBorder((phraseCategory == selectedPhraseCategory ? Color.primary : Color(.secondarySystemBackground)), width: 0.5, radius: 4)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationDestination(isPresented: $showingPhraseCategoryListView) {
            PhraseCategoryListView()
        }
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

private struct RoundedBorderModifier<Style: ShapeStyle>: ViewModifier {
    var style: Style, width: CGFloat = 0, radius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: radius)
                    .stroke(lineWidth: width*2)
                    .fill(style)
            }
            .mask {
                RoundedRectangle(cornerRadius: radius)
            }
    }
}

private extension View {
    func roundedBorder<S: ShapeStyle>(
        _ style: S,
        width: CGFloat,
        radius: CGFloat
    ) -> some View {
        let modifier = RoundedBorderModifier(
            style: style,
            width: width,
            radius: radius
        )
        return self.modifier(modifier)
    }
}

#Preview {
    @Previewable @State var selectedCategory: PhraseCategory? = .init(id: .init(0), createdAt: .now, metadata: .init(name: "home", icon: .init(name: "house.fill", color: .blue)), phrases: [])
    let phraseCategories: [PhraseCategory] = [selectedCategory!, .init(id: .init(2), createdAt: .now, metadata: .init(name: "Health", icon: .init(name: "heart.fill", color: .pink)), phrases: [])]
    PhraseCategoryListHeader(phraseCategories: phraseCategories, selectedPhraseCategory: $selectedCategory)
}
