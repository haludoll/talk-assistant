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
    @State private var conversationViewModel = ConversationViewModel()
    @StateObject private var phraseCategoryListViewModel = PhraseCategoryListViewModel()
    @FocusState private var phraseTextFieldFocused: Bool

    public init() {}

    public var body: some View {
        VStack(alignment: .leading) {
            PhraseCategoryListHeader(phraseCategories: phraseCategoryListViewModel.phraseCategories)

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                RepeatButton {
                    conversationViewModel.text = conversationViewModel.lastText
                    conversationViewModel.speak()
                }
                .disabled(conversationViewModel.lastText.isEmpty)

                PhraseTextField(conversationViewModel: conversationViewModel, focused: $phraseTextFieldFocused)
            }
            .padding()
        }
        .contentShape(Rectangle())
        .background(
            LinearGradient(gradient: Gradient(colors: [.mint, .white]), startPoint: .top, endPoint: .center)
        )
        .onTapGesture {
            phraseTextFieldFocused = false
        }
        .onAppear {
            conversationViewModel.setupVoice()
        }
        .task {
            await conversationViewModel.observeSpeechDelegate()
            phraseCategoryListViewModel.fetchAll()
        }
    }
}

private struct PhraseCategoryListHeader: View {
    @State private var showingPhraseCategoryListView = false
    let phraseCategories: [PhraseCategory]

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

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(0..<5) { phraseCategory in
                        Button {

                        } label: {
                            Label {
                                //Text(phraseCategory.metadata.name)
                                Text("home")
                            } icon: {
    //                            Image(systemName: phraseCategory.metadata.icon.name)
    //                                .foregroundStyle(phraseCategory.metadata.icon.color)
                                Image(systemName: "house.fill")
                                    .foregroundStyle(.blue)
                            }
                            //.font(.headline)
                            .foregroundStyle(phraseCategory == 1 ? Color.primary : Color(.secondaryLabel))
                            .labelStyle(.phraseCategoryLabel)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(phraseCategory == 1 ? Color(.systemBackground) : Color(.systemGroupedBackground))
                            .cornerRadius(4)
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


#Preview {
    NavigationStack {
        ConversationView()
    }
}
