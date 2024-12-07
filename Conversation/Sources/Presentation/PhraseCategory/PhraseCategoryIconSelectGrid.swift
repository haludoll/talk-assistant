//
//  PhraseCategoryIconSelectGrid.swift
//  Conversation
//
//  Created by haludoll on 2024/12/08.
//

import SwiftUI
import Algorithms
import ConversationEntity

struct PhraseCategoryIconSelectGrid: View {
    let icon: PhraseCategory.Metadata.Icon
    let select: (String) -> Void

    private let icons = ["house.fill", "heart.fill", "clock.fill", "pencil.line", "sun.max.fill", "moon.fill", "building.2.fill", "laptopcomputer", "iphone.gen1", "gamecontroller.fill", "figure.walk", "dumbbell.fill", "text.bubble.fill", "phone.fill", "video.fill", "envelope.fill", "car.fill", "airplane", "bus", "tram.fill", "book.fill", "fork.knife", "wineglass.fill", "scissors", "cart.fill", "stethoscope", "pill.fill", "cross.case.fill", "toilet.fill", "headphones", "tshirt.fill", "figure.2", "textformat.size", "lock.fill"
    ]

    var body: some View {
        Grid(horizontalSpacing: 24, verticalSpacing: 24) {
            ForEach(icons.chunks(ofCount: 6), id: \.self) { row in
                GridRow {
                    ForEach(row, id: \.self) { iconName in
                        Button {
                            select(iconName)
                        } label: {
                            ZStack {
                                if icon.name == iconName {
                                    Circle()
                                        .foregroundStyle(icon.color)
                                        .scaleEffect(1.35)
                                        .frame(maxWidth: 44)

                                    Circle()
                                        .foregroundStyle(Color(.systemBackground))
                                        .scaleEffect(1.2)
                                        .frame(maxWidth: 44)
                                }

                                Circle()
                                    .foregroundStyle(icon.name == iconName ? icon.color.opacity(0.2) :  Color(.secondarySystemBackground))
                                    .overlay {
                                        Image(systemName: iconName)
                                            .foregroundStyle(icon.name == iconName ? icon.color : Color(.secondaryLabel))
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
    }
}

#Preview {
    @Previewable @State var icon = PhraseCategory.Metadata.Icon(name: "house.fill", color: .blue)
    PhraseCategoryIconSelectGrid(icon: icon) { icon.name = $0 }
}
