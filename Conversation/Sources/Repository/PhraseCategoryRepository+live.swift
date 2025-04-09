//
//  PhraseCategoryRepository+live.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import ConversationEntity
import LocalStorage
import SwiftData
import Foundation

extension PhraseCategoryRepository {
    private static let setDefaultPhraseCategoryUserDefaultsKey = "set_default_phrase_category"

    package static func live() -> Self {
        Self(
            fetch: { id in
                var descriptor = FetchDescriptor<PhraseCategory>(predicate: #Predicate { $0.id == id })
                descriptor.fetchLimit = 1
                guard let category = try ModelContainer.appContainer.mainContext.fetch(descriptor).first else { fatalError() }
                category.phrases.sort(by: { $0.createdAt > $1.createdAt })
                return category
            },
            fetchAll: {
                try ModelContainer.appContainer.mainContext.fetch(FetchDescriptor<PhraseCategory>(sortBy: [.init(\.createdAt)]))
            },
            create: { phraseCategory in
                ModelContainer.appContainer.mainContext.insert(phraseCategory)
                try ModelContainer.appContainer.mainContext.save()
            },
            delete: { phraseCategoryToDelete in
                ModelContainer.appContainer.mainContext.delete(phraseCategoryToDelete)
                try ModelContainer.appContainer.mainContext.save()
            },
            edit: { phraseCategoryToUpdate in
                ModelContainer.appContainer.mainContext.insert(phraseCategoryToUpdate)
                try ModelContainer.appContainer.mainContext.save()
            }
        )
    }

    @MainActor
    package static func createDefault(userDefaults: UserDefaults = .standard) throws {
        if !userDefaults.bool(forKey: Self.setDefaultPhraseCategoryUserDefaultsKey) {
            let defaultPhraseCategory = PhraseCategory(id: .init(),
                                                       createdAt: .now,
                                                       metadata: .init(name: .init(localized: "Common Phrases", bundle: .module),
                                                                       icon: .init(name: "heart.fill", color: .pink)),
                                                       phrases: [
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "Goodbye", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "Please say that again", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "I'm okay", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "Excuse me", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "Thank you", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "No", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "Yes", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "Good evening", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "Hello", bundle: .module)),
                                                        .init(id: .init(), createdAt: .now, value: .init(localized: "Good morning", bundle: .module))
                                                       ])
            ModelContainer.appContainer.mainContext.insert(defaultPhraseCategory)
            try ModelContainer.appContainer.mainContext.save()
            userDefaults.set(true, forKey: Self.setDefaultPhraseCategoryUserDefaultsKey)
            return
        }
    }
}
