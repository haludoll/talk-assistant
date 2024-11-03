//
//  PhraseCategoryRepository+live.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import ConversationEntity
import SwiftData

extension PhraseCategoryRepository {
    package static func live(modelContainer: ModelContainer = try! .init(for: PhraseCategory.self, configurations: .init(isStoredInMemoryOnly: true))) -> Self {
        Self(
            fetchAll: {
                return try modelContainer.mainContext.fetch(FetchDescriptor<PhraseCategory>())
            },
            create: { phraseCategory in
                modelContainer.mainContext.insert(phraseCategory)
                try modelContainer.mainContext.save()
            }
        )
    }
}
