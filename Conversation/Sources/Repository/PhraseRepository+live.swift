//
//  PhraseRepository+live.swift
//  Conversation
//
//  Created by haludoll on 2024/12/08.
//

import ConversationEntity
import SwiftData
import Foundation

extension PhraseRepository {
    package static func live(modelContainer: ModelContainer = try! .init(for: Phrase.self, configurations: .init())) -> Self {
        return Self(
            create: { phrase in
                modelContainer.mainContext.insert(phrase)
                try modelContainer.mainContext.save()
            }
        )
    }
}
