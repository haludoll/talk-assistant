//
//  PhraseCategoryRepository.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

package struct PhraseCategoryRepository: Sendable {
    package let fetch: @MainActor (PhraseCategory.ID) throws -> PhraseCategory
    package let fetchAll: @MainActor () throws -> [PhraseCategory]
    package let create: @MainActor (PhraseCategory) throws -> Void
    package let delete: @MainActor (PhraseCategory) throws -> Void
    package let edit: @MainActor (PhraseCategory) throws -> Void

    package init(fetch: @escaping @MainActor (PhraseCategory.ID) throws -> PhraseCategory,
                 fetchAll: @escaping @MainActor () throws -> [PhraseCategory],
                 create: @escaping @MainActor (PhraseCategory) throws -> Void,
                 delete: @escaping @MainActor (PhraseCategory) throws -> Void,
                 edit: @escaping @MainActor (PhraseCategory) throws -> Void) {
        self.fetch = fetch
        self.fetchAll = fetchAll
        self.create = create
        self.delete = delete
        self.edit = edit
    }
}
