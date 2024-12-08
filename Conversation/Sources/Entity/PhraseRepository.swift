//
//  PhraseRepository.swift
//  Conversation
//
//  Created by haludoll on 2024/12/08.
//

package struct PhraseRepository: Sendable {
    package let create: @MainActor (Phrase) throws -> Void

    package init(create: @escaping @MainActor (Phrase) throws -> Void) {
        self.create = create
    }
}
