//
//  PhraseCategoryEditView.swift
//  Conversation
//
//  Created by haludoll on 2024/12/07.
//

import SwiftUI
import ConversationViewModel
import ConversationEntity
import Algorithms

struct PhraseCategoryEditView: View {
    @State private var phraseCategoryEditViewModel: PhraseCategoryEditViewModel
    @Environment(\.dismiss) private var dismiss

    private let colors: [Color] = [.red, .pink, .orange, .yellow, .green, .purple, .indigo, .blue, .teal, .mint, .cyan, .brown, .gray]
    private let icons = ["house.fill", "heart.fill", "clock.fill", "pencil.line", "sun.max.fill", "moon.fill", "building.2.fill", "laptopcomputer", "iphone.gen1", "gamecontroller.fill", "figure.walk", "dumbbell.fill", "text.bubble.fill", "phone.fill", "video.fill", "envelope.fill", "car.fill", "airplane", "bus", "tram.fill", "book.fill", "fork.knife", "wineglass.fill", "scissors", "cart.fill", "stethoscope", "pill.fill", "cross.case.fill", "toilet.fill", "headphones", "tshirt.fill", "figure.2", "textformat.size", "lock.fill"
    ]

    init(phraseCategory: PhraseCategory) {
        self._phraseCategoryEditViewModel = .init(initialValue: .init(phraseCategory: phraseCategory))
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 32) {
                        Text("Edit the Category", bundle: .module)
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

                        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                            ForEach(colors.chunks(ofCount: (colors.count / 2) + 1), id: \.self) { row in
                                GridRow {
                                    ForEach(row, id: \.self) { color in
                                        ZStack {
                                            if phraseCategoryEditViewModel.iconColor == color {
                                                Circle()
                                                    .foregroundStyle(Color.secondary)
                                                    .scaleEffect(1.35)
                                                    .frame(maxWidth: 44)

                                                Circle()
                                                    .foregroundStyle(Color(.systemBackground))
                                                    .scaleEffect(1.2)
                                                    .frame(maxWidth: 44)
                                            }

                                            Button {
                                                phraseCategoryEditViewModel.iconColor = color
                                            } label: {
                                                Circle()
                                                    .foregroundStyle(color)
                                                    .frame(maxWidth: 44)
                                            }
                                        }

                                        if let lastColor = colors.last,
                                           lastColor == color {
                                            ZStack {
                                                if !colors.contains(phraseCategoryEditViewModel.iconColor) {
                                                    Circle()
                                                        .foregroundStyle(Color.secondary)
                                                        .scaleEffect(1.35)
                                                        .frame(maxWidth: 44)

                                                    Circle()
                                                        .foregroundStyle(Color(.systemBackground))
                                                        .scaleEffect(1.2)
                                                        .frame(maxWidth: 44)
                                                }
                                                ColorPicker("", selection: $phraseCategoryEditViewModel.iconColor)
                                                    .scaleEffect(1.2)
                                                    .labelsHidden()
                                                    .frame(maxWidth: 44)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                        Grid(horizontalSpacing: 24, verticalSpacing: 24) {
                            ForEach(icons.chunks(ofCount: 6), id: \.self) { row in
                                GridRow {
                                    ForEach(row, id: \.self) { iconName in
                                        Button {
                                            phraseCategoryEditViewModel.iconName = iconName
                                        } label: {
                                            ZStack {
                                                if phraseCategoryEditViewModel.iconName == iconName {
                                                    Circle()
                                                        .foregroundStyle(phraseCategoryEditViewModel.iconColor)
                                                        .scaleEffect(1.35)
                                                        .frame(maxWidth: 44)

                                                    Circle()
                                                        .foregroundStyle(Color(.systemBackground))
                                                        .scaleEffect(1.2)
                                                        .frame(maxWidth: 44)
                                                }

                                                Circle()
                                                    .foregroundStyle(phraseCategoryEditViewModel.iconName == iconName ? phraseCategoryEditViewModel.iconColor.opacity(0.2) :  Color(.secondarySystemBackground))
                                                    .overlay {
                                                        Image(systemName: iconName)
                                                            .foregroundStyle(phraseCategoryEditViewModel.iconName == iconName ? phraseCategoryEditViewModel.iconColor : Color(.secondaryLabel))
                                                            .scaleEffect(1.15)
                                                            .dynamicTypeSize(.medium ... .xLarge)
                                                    }
                                                    .frame(maxWidth: 60)
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                }
                            }
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
            PhraseCategoryEditView(phraseCategory: .init(id: .init(), metadata: .init(name: "home", icon: .init(name: "house.fill", color: .blue)), phrases: []))
        }
}
