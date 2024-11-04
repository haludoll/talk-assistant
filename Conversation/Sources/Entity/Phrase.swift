//
//  Phrase.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import SwiftData

@Model
package final class Phrase {
    package var value: String
    package var category: PhraseCategory?

    package init(value: String, category: PhraseCategory? = nil) {
        self.value = value
        self.category = category
    }
}
