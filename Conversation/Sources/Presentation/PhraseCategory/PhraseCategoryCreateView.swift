//
//  PhraseCategoryCreateView.swift
//  Conversation
//
//  Created by haludoll on 2024/11/05.
//

import SwiftUI
import ConversationViewModel

struct PhraseCategoryCreateView: View {
    @State private var phraseCategoryCreateViewModel = PhraseCategoryCreateViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 16) {
                        Image(systemName: phraseCategoryCreateViewModel.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(phraseCategoryCreateViewModel.iconColor)

                        TextField(String(localized: "Category Name", bundle: .module), text: $phraseCategoryCreateViewModel.categoryName)
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                }

                Section {
                    PhraseCategoryIconColorSelectGrid(selectedIconColor: phraseCategoryCreateViewModel.iconColor) {
                        phraseCategoryCreateViewModel.iconColor = $0
                    }
                }

                PhraseCategoryIconSelectGrid(iconName: phraseCategoryCreateViewModel.iconName,
                                             iconColor: phraseCategoryCreateViewModel.iconColor) {
                    phraseCategoryCreateViewModel.iconName = $0
                }
            }
            .listSectionSpacing(16)
            .navigationTitle(Text("New Category", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss", systemImage: "xmark") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") {
                        phraseCategoryCreateViewModel.create()
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
            PhraseCategoryCreateView()
        }
}
