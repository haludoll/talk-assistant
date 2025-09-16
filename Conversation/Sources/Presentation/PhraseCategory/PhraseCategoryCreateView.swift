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
            VStack {
                ScrollView {
                    VStack(spacing: 32) {
                        Text("Create a Category", bundle: .module)
                            .bold()
                            .font(.largeTitle)
                            .padding(.bottom)

                        Image(systemName: phraseCategoryCreateViewModel.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(phraseCategoryCreateViewModel.iconColor)

                        TextField(String(localized: "Name", bundle: .module), text: $phraseCategoryCreateViewModel.categoryName)
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)

                        PhraseCategoryIconColorSelectGrid(selectedIconColor: phraseCategoryCreateViewModel.iconColor) {
                            phraseCategoryCreateViewModel.iconColor = $0
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                        PhraseCategoryIconSelectGrid(iconName: phraseCategoryCreateViewModel.iconName,
                                                     iconColor: phraseCategoryCreateViewModel.iconColor) {
                            phraseCategoryCreateViewModel.iconName = $0
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding(.top, 64)
                    .padding(.horizontal)
                }

                Button {
                    phraseCategoryCreateViewModel.create()
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
            PhraseCategoryCreateView()
        }
}
