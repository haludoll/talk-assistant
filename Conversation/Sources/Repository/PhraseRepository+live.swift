//
//  PhraseRepository+live.swift
//  Conversation
//
//  Created by haludoll on 2024/12/08.
//

import ConversationEntity
import LocalStorage
import SwiftData

extension PhraseRepository {
    package static func live() -> Self {
        return Self(
            create: { phrase in
                ModelContainer.appContainer.mainContext.insert(phrase)
                try ModelContainer.appContainer.mainContext.save()
            }
        )
    }
}
