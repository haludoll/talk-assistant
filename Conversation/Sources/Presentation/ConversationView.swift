//
//  ConversationiView.swift
//  Conversation
//
//  Created by haludoll on 2024/10/06.
//

import SwiftUI
import ConversationViewModel
import ConversationEntity

public struct ConversationView: View {
    @State private var typeToSpeakViewModel = TypeToSpeakViewModel()
    @State private var phraseCategorySpeakViewModel = PhraseCategorySpeakViewModel()
    @FocusState private var phraseTextFieldFocused: Bool

    public init() {}

    public var body: some View {
        VStack(alignment: .leading) {
            PhraseCategoryListHeader(phraseCategories: phraseCategorySpeakViewModel.phraseCategories,
                                     selectedPhraseCategory: .init(get: { phraseCategorySpeakViewModel.selectedPhraseCategory },
                                                                   set: { phraseCategorySpeakViewModel.selectedPhraseCategory = $0 }))

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                RepeatButton {
                    typeToSpeakViewModel.text = typeToSpeakViewModel.lastText
                    typeToSpeakViewModel.speak()
                }
                .disabled(typeToSpeakViewModel.lastText.isEmpty)

                PhraseTextField(typeToSpeakViewModel: typeToSpeakViewModel, focused: $phraseTextFieldFocused)
            }
            .padding()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            phraseTextFieldFocused = false
        }
        .onAppear {
            typeToSpeakViewModel.setupVoice()
            phraseCategorySpeakViewModel.fetchPhraseCategories()
        }
        .task {
            await typeToSpeakViewModel.observeSpeechDelegate()
        }
    }
}

private struct PhraseCategoryListHeader: View {
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
    NavigationStack {
        ConversationView()
    }
}
