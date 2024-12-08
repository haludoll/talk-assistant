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
import Foundation

extension PhraseCategoryRepository {
    package static func live() -> Self {
        Self(
            fetch: { id in
                var descriptor = FetchDescriptor<PhraseCategory>(predicate: #Predicate { $0.id == id })
                descriptor.fetchLimit = 1
                guard let category = try ModelContainer.appContainer.mainContext.fetch(descriptor).first else { fatalError() }
                return category
            },
            fetchAll: {
                try ModelContainer.appContainer.mainContext.fetch(FetchDescriptor<PhraseCategory>())
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
}
