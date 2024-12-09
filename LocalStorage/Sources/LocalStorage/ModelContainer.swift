//
//  ModelContainer.swift
//  LocalStorage
//
//  Created by haludoll on 2024/12/08.
//

@preconcurrency import SwiftData
import ConversationEntity

extension ModelContainer {
    static let configurations = ModelConfiguration(for: PhraseCategory.self, Phrase.self)
    public static let appContainer = try! ModelContainer(for: PhraseCategory.self, Phrase.self, configurations: configurations)
}
