//
//  PhraseCategoryRepository.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

package struct PhraseCategoryRepository: Sendable {
    package let findCategory: @Sendable (PhraseCategoryAggregate.ID) async throws -> PhraseCategoryAggregate
    package let listCategories: @Sendable () async throws -> [PhraseCategoryAggregate]
    package let saveCategory: @Sendable (PhraseCategoryAggregate) async throws -> Void
    package let deleteCategory: @Sendable (PhraseCategoryAggregate.ID) async throws -> Void
    package let createDefaultCategoryIfNeeded: @Sendable () async throws -> Void
    package let appendPhrase: @Sendable (PhraseCategoryAggregate.ID, PhraseCategoryAggregate.Phrase) async throws -> Void
    package let removePhrase: @Sendable (PhraseCategoryAggregate.ID, PhraseCategoryAggregate.Phrase.ID) async throws -> Void

    package init(findCategory: @escaping @Sendable (PhraseCategoryAggregate.ID) async throws -> PhraseCategoryAggregate,
                 listCategories: @escaping @Sendable () async throws -> [PhraseCategoryAggregate],
                 saveCategory: @escaping @Sendable (PhraseCategoryAggregate) async throws -> Void,
                 deleteCategory: @escaping @Sendable (PhraseCategoryAggregate.ID) async throws -> Void,
                 createDefaultCategoryIfNeeded: @escaping @Sendable () async throws -> Void,
                 appendPhrase: @escaping @Sendable (PhraseCategoryAggregate.ID, PhraseCategoryAggregate.Phrase) async throws -> Void,
                 removePhrase: @escaping @Sendable (PhraseCategoryAggregate.ID, PhraseCategoryAggregate.Phrase.ID) async throws -> Void) {
        self.findCategory = findCategory
        self.listCategories = listCategories
        self.saveCategory = saveCategory
        self.deleteCategory = deleteCategory
        self.createDefaultCategoryIfNeeded = createDefaultCategoryIfNeeded
        self.appendPhrase = appendPhrase
        self.removePhrase = removePhrase
    }
}
