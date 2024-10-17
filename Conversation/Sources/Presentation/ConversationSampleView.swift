//
//  ConversationSampleView.swift
//  Conversation
//
//  Created by haludoll on 2024/10/11.
//

import SwiftUI

private struct ConversationSampleView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        Section {
                            LazyVStack(pinnedViews: .sectionHeaders) {
                                Section {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("語句")
                                            .bold()
                                            .font(.title2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)

                                        ForEach(0..<3) { _ in
                                            Text("こんにちは")
                                                .font(.title3)
                                                .padding(12)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                                .cornerRadius(8)
                                                .padding(.bottom, 8)

                                        }
                                        .padding(.horizontal)

                                    }
                                } header: {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(0..<10) { i in

                                                Button {

                                                } label: {
                                                    Label("病院", systemImage: "phone.fill")
                                                        .bold()
                                                        .font(.callout)
                                                        .labelStyle(.phraseCategoryLabel)
                                                        .foregroundStyle(i == 1 ? .white : Color(UIColor.secondaryLabel))
                                                        .padding(.vertical, 8)
                                                        .padding(.horizontal, 12)
                                                        .multilineTextAlignment(.leading)
                                                        .background(i == 1 ? Color.accentColor : Color(UIColor.secondarySystemGroupedBackground))
                                                        .cornerRadius(8)
                                                }

                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .padding(.vertical, 8)
                                    .background(Color(UIColor.systemGroupedBackground))
                                }
                            }
                        } header: {
                            Text("分類")
                                .bold()
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

private struct PhraseCategoryLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 2) {
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
        ConversationSampleView()
            .navigationTitle("読み上げ")
    }
}

