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
    package var value: String
    package var category: PhraseCategory?

    package init(id: UUID, value: String, category: PhraseCategory? = nil) {
        self.id = id
        self.value = value
        self.category = category
    }
}
