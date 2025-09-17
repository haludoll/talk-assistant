//
//  Phrase.swift
//  ConversationPersistenceModel
//
//  Created by ChatGPT on 2025/09/16.
//

import Foundation
import SwiftData

@Model
public final class Phrase {
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date
    public var value: String
    public var category: PhraseCategory?

    public init(id: UUID, createdAt: Date, value: String, category: PhraseCategory? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.value = value
        self.category = category
    }
}
