//
//  Phrase.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import SwiftData
import Foundation

@Model
public final class Phrase {
    @Attribute(.unique) public var id: UUID
    package var createdAt: Date
    package var value: String
    package var category: PhraseCategory?

    package init(id: UUID, createdAt: Date, value: String, category: PhraseCategory? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.value = value
        self.category = category
    }
}
