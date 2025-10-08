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
            List {
                Section {
                    VStack(spacing: 16) {
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
                    }
                }

                Section {
                    PhraseCategoryIconColorSelectGrid(selectedIconColor: phraseCategoryEditViewModel.iconColor) {
                        phraseCategoryEditViewModel.iconColor = $0
                    }
                }

                Section {
                    PhraseCategoryIconSelectGrid(iconName: phraseCategoryEditViewModel.iconName,
                                                 iconColor: phraseCategoryEditViewModel.iconColor) {
                        phraseCategoryEditViewModel.iconName = $0
                    }
                }
            }
            .listSectionSpacing(16)
            .navigationTitle(Text("Edit Category", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss", systemImage: "xmark") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") {
                        phraseCategoryEditViewModel.edit()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true)) {
            PhraseCategoryEditView(phraseCategory: .init(id: .init(), createdAt: .now, name: "home", icon: .init(systemName: "house.fill", color: .init(red: 0.0, green: 0.478, blue: 1.0)), phrases: []))
        }
}
