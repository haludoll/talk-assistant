//
//  PhraseCategoryRepository.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

package struct PhraseCategoryRepository: Sendable {
    package let fetchAll: @MainActor () throws -> [PhraseCategory]
    package let create: @MainActor (PhraseCategory) throws -> Void

    package init(fetchAll: @escaping @MainActor () throws -> [PhraseCategory], create: @escaping @MainActor (PhraseCategory) throws -> Void) {
        self.fetchAll = fetchAll
        self.create = create
    }
}
