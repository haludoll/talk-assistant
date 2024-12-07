//
//  PhraseCategoryRepository+live.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import ConversationEntity
import SwiftData
import Foundation

extension PhraseCategoryRepository {
    package static func live(modelContainer: ModelContainer = try! .init(for: PhraseCategory.self, configurations: .init(isStoredInMemoryOnly: false))) -> Self {
        Self(
            fetch: { id in
                var descriptor = FetchDescriptor<PhraseCategory>(predicate: #Predicate { $0.id == id })
                descriptor.fetchLimit = 1
                guard let category = try modelContainer.mainContext.fetch(descriptor).first else { fatalError() }
                return category
            },
            fetchAll: {
                try modelContainer.mainContext.fetch(FetchDescriptor<PhraseCategory>())
            },
            create: { phraseCategory in
                modelContainer.mainContext.insert(phraseCategory)
                try modelContainer.mainContext.save()
            },
            delete: { phraseCategoryToDelete in
                modelContainer.mainContext.delete(phraseCategoryToDelete)
                try modelContainer.mainContext.save()
            },
            edit: { phraseCategoryToUpdate in
                modelContainer.mainContext.insert(phraseCategoryToUpdate)
                try modelContainer.mainContext.save()
            }
        )
    }
}
