import ConversationEntity
import ConversationPersistenceModel
import Foundation
import LocalStorageCore
import SwiftData
import SwiftUI

extension PhraseCategoryRepository {
    private static let setDefaultPhraseCategoryUserDefaultsKey = "set_default_phrase_category"

    package static func live(store: PersistentStoreActor = .shared, userDefaults: UserDefaults = .standard) -> Self {
        .init(
            findCategory: { id in
                try await store.withContext { context in
                    try fetchCategory(id: id, context: context).toAggregate
                }
            },
            listCategories: {
                try await store.withContext { context in
                    let descriptor = FetchDescriptor<ConversationPersistenceModel.PhraseCategory>(
                        sortBy: [
                            .init(\.sortOrder, order: .forward),
                            .init(\.createdAt, order: .forward)
                        ]
                    )
                    return try context.fetch(descriptor).map { $0.toAggregate }
                }
            },
            createCategory: { aggregate in
                try await store.withContext { context in
                    var newAggregate = aggregate
                    newAggregate.sortOrder = try nextSortOrder(in: context)
                    context.insert(newAggregate.toPersistenceModel)
                    try context.save()
                }
            },
            updateCategory: { aggregate in
                try await store.withContext { context in
                    let existing = try fetchCategory(id: aggregate.id, context: context)
                    existing.createdAt = aggregate.createdAt
                    existing.metadata = aggregate.toMetadata
                    existing.sortOrder = aggregate.sortOrder
                    try context.save()
                }
            },
            deleteCategory: { id in
                try await store.withContext { context in
                    let category = try fetchCategory(id: id, context: context)
                    context.delete(category)
                    try context.save()
                }
            },
            createDefaultCategoryIfNeeded: {
                guard !userDefaults.bool(forKey: setDefaultPhraseCategoryUserDefaultsKey) else { return }
                try await store.withContext { context in
                    context.insert(makeDefaultCategory().toPersistenceModel)
                    try context.save()
                }
                userDefaults.set(true, forKey: setDefaultPhraseCategoryUserDefaultsKey)
            },
            appendPhrase: { categoryID, phrase in
                try await store.withContext { context in
                    let categoryModel = try fetchCategory(id: categoryID, context: context)

                    let newPhrase = Phrase(
                        id: phrase.id,
                        createdAt: phrase.createdAt,
                        value: phrase.value,
                        category: categoryModel
                    )
                    categoryModel.phrases.insert(newPhrase, at: 0)
                    categoryModel.phrases.sort(by: { $0.createdAt > $1.createdAt })
                    try context.save()
                }
            },
            removePhrase: { categoryID, phraseID in
                try await store.withContext { context in
                    let categoryModel = try fetchCategory(id: categoryID, context: context)
                    guard let index = categoryModel.phrases.firstIndex(where: { $0.id == phraseID }) else { return }
                    let phrase = categoryModel.phrases.remove(at: index)
                    context.delete(phrase)
                    try context.save()
                }
            },
            reorderCategories: { orderedIDs in
                try await store.withContext { context in
                    try applyCategoryOrder(orderedIDs, in: context)
                }
            }
        )
    }

    static func applyCategoryOrder(_ orderedIDs: [UUID], in context: ModelContext) throws {
        let categories = try context.fetch(FetchDescriptor<ConversationPersistenceModel.PhraseCategory>())
        guard !categories.isEmpty else { return }

        let lookup = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })

        for (index, id) in orderedIDs.enumerated() {
            lookup[id]?.sortOrder = index
        }

        try context.save()
    }

    static func nextSortOrder(in context: ModelContext) throws -> Int {
        var descriptor = FetchDescriptor<ConversationPersistenceModel.PhraseCategory>(
            sortBy: [
                .init(\.sortOrder, order: .reverse),
                .init(\.createdAt, order: .reverse)
            ]
        )
        descriptor.fetchLimit = 1
        if let last = try context.fetch(descriptor).first {
            return max(last.sortOrder + 1, 0)
        }
        return 0
    }

    static func fetchCategory(id: UUID, context: ModelContext) throws -> ConversationPersistenceModel.PhraseCategory {
        var descriptor = FetchDescriptor<ConversationPersistenceModel.PhraseCategory>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        guard let category = try context.fetch(descriptor).first else { fatalError() }
        return category
    }

    private static func makeDefaultCategory() -> ConversationEntity.PhraseCategory {
        .init(
            id: .init(),
            createdAt: .now,
            name: String(localized: "Common Phrases", bundle: .module),
            icon: .init(systemName: "heart.fill", color: .init(color: Color.pink)),
            sortOrder: 0,
            phrases: [
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "Goodbye", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "Please say that again", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "I'm okay", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "Excuse me", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "Thank you", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "No", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "Yes", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "Good evening", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "Hello", bundle: .module), categoryID: nil),
                ConversationEntity.PhraseCategory.Phrase(id: .init(), createdAt: .now, value: String(localized: "Good morning", bundle: .module), categoryID: nil)
            ]
        )
    }
}

extension UserDefaults: @unchecked @retroactive Sendable {}
