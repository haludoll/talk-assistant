//
//  PhraseCategoryRepository.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

package struct PhraseCategoryRepository: Sendable {
    package let findCategory: @Sendable (PhraseCategory.ID) async throws -> PhraseCategory
    package let listCategories: @Sendable () async throws -> [PhraseCategory]
    package let saveCategory: @Sendable (PhraseCategory) async throws -> Void
    package let deleteCategory: @Sendable (PhraseCategory.ID) async throws -> Void
    package let createDefaultCategoryIfNeeded: @Sendable () async throws -> Void
    package let appendPhrase: @Sendable (PhraseCategory.ID, PhraseCategory.Phrase) async throws -> Void
    package let removePhrase: @Sendable (PhraseCategory.ID, PhraseCategory.Phrase.ID) async throws -> Void
    package let reorderCategories: @Sendable ([PhraseCategory.ID]) async throws -> Void

    package init(findCategory: @escaping @Sendable (PhraseCategory.ID) async throws -> PhraseCategory,
                 listCategories: @escaping @Sendable () async throws -> [PhraseCategory],
                 saveCategory: @escaping @Sendable (PhraseCategory) async throws -> Void,
                 deleteCategory: @escaping @Sendable (PhraseCategory.ID) async throws -> Void,
                 createDefaultCategoryIfNeeded: @escaping @Sendable () async throws -> Void,
                 appendPhrase: @escaping @Sendable (PhraseCategory.ID, PhraseCategory.Phrase) async throws -> Void,
                 removePhrase: @escaping @Sendable (PhraseCategory.ID, PhraseCategory.Phrase.ID) async throws -> Void,
                 reorderCategories: @escaping @Sendable ([PhraseCategory.ID]) async throws -> Void) {
        self.findCategory = findCategory
        self.listCategories = listCategories
        self.saveCategory = saveCategory
        self.deleteCategory = deleteCategory
        self.createDefaultCategoryIfNeeded = createDefaultCategoryIfNeeded
        self.appendPhrase = appendPhrase
        self.removePhrase = removePhrase
        self.reorderCategories = reorderCategories
    }
}
