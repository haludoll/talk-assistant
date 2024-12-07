//
//  PhraseCategoryIconColorSelectGrid.swift
//  Conversation
//
//  Created by haludoll on 2024/12/08.
//

import SwiftUI
import Algorithms

struct PhraseCategoryIconColorSelectGrid: View {
    let selectedIconColor: Color
    let select: (Color) -> Void
    private let colors: [Color] = [.red, .pink, .orange, .yellow, .green, .purple, .indigo, .blue, .teal, .mint, .cyan, .brown, .gray]

    var body: some View {
        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
            ForEach(colors.chunks(ofCount: (colors.count / 2) + 1), id: \.self) { row in
                GridRow {
                    ForEach(row, id: \.self) { color in
                        ZStack {
                            if selectedIconColor == color {
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
                                select(color)
                            } label: {
                                Circle()
                                    .foregroundStyle(color)
                                    .frame(maxWidth: 44)
                            }
                        }

                        if let lastColor = colors.last,
                           lastColor == color {
                            ZStack {
                                if !colors.contains(selectedIconColor) {
                                    Circle()
                                        .foregroundStyle(Color.secondary)
                                        .scaleEffect(1.35)
                                        .frame(maxWidth: 44)

                                    Circle()
                                        .foregroundStyle(Color(.systemBackground))
                                        .scaleEffect(1.2)
                                        .frame(maxWidth: 44)
                                }
                                ColorPicker("", selection: .init(get: { selectedIconColor },
                                                                 set: { select($0) }))
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
    }
}

#Preview {
    @Previewable @State var color = Color.blue
    PhraseCategoryIconColorSelectGrid(selectedIconColor: color, select: { color = $0 })
}
