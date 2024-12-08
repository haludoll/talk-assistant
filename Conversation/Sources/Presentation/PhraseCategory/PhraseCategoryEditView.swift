//
//  PhraseCategoryEditView.swift
//  Conversation
//
//  Created by haludoll on 2024/12/07.
//

import SwiftUI
import ConversationViewModel
import ConversationEntity

struct PhraseCategoryEditView: View {
    @State private var phraseCategoryEditViewModel: PhraseCategoryEditViewModel
    @Environment(\.dismiss) private var dismiss

    init(phraseCategory: PhraseCategory) {
        self._phraseCategoryEditViewModel = .init(initialValue: .init(phraseCategory: phraseCategory))
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 32) {
                        Text("Edit Category", bundle: .module)
                            .bold()
                            .font(.largeTitle)
                            .padding(.bottom)

                        Image(systemName: phraseCategoryEditViewModel.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(phraseCategoryEditViewModel.iconColor)

                        TextField(String(localized: "Name", bundle: .module), text: $phraseCategoryEditViewModel.categoryName)
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)

                        PhraseCategoryIconColorSelectGrid(selectedIconColor: phraseCategoryEditViewModel.iconColor) {
                            phraseCategoryEditViewModel.iconColor = $0
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                        PhraseCategoryIconSelectGrid(icon: .init(name: phraseCategoryEditViewModel.iconName, color: phraseCategoryEditViewModel.iconColor)) {
                            phraseCategoryEditViewModel.iconName = $0
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding(.top, 64)
                    .padding(.horizontal)
                }

                Button {
                    phraseCategoryEditViewModel.edit()
                    dismiss()
                } label: {
                    Text("Done", bundle: .module)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                .bold()
                .font(.headline)
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
                .padding(.top, 8)
                .padding(.horizontal, 32)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true)) {
            PhraseCategoryEditView(phraseCategory: .init(id: .init(), sortOrder: 0, metadata: .init(name: "home", icon: .init(name: "house.fill", color: .blue)), phrases: []))
        }
}
