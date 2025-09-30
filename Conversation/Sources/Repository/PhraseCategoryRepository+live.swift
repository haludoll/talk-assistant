import ConversationEntity
import ConversationPersistenceModel
import Foundation
import LocalStorageCore
import SwiftData
import SwiftUI
import UIKit

private enum PhraseCategoryRepositoryError: Error {
    case notFound
}

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
            saveCategory: { aggregate in
                try await store.withContext { context in
                    if let existing = try? fetchCategory(id: aggregate.id, context: context) {
                        existing.createdAt = aggregate.createdAt
                        existing.metadata = aggregate.toMetadata
                        existing.sortOrder = aggregate.sortOrder
                    } else {
                        var newAggregate = aggregate
                        newAggregate.sortOrder = try nextSortOrder(in: context)
                        context.insert(newAggregate.toPersistenceModel)
                    }
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

    private static func fetchCategory(id: UUID, context: ModelContext) throws -> ConversationPersistenceModel.PhraseCategory {
        var descriptor = FetchDescriptor<ConversationPersistenceModel.PhraseCategory>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        guard let category = try context.fetch(descriptor).first else {
            throw PhraseCategoryRepositoryError.notFound
        }
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

private func applyCategoryOrder(_ orderedIDs: [UUID], in context: ModelContext) throws {
    let categories = try context.fetch(FetchDescriptor<ConversationPersistenceModel.PhraseCategory>())
    guard !categories.isEmpty else { return }

    let lookup = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
    var seen = Set<UUID>()

    for (index, id) in orderedIDs.enumerated() {
        guard let category = lookup[id] else { continue }
        category.sortOrder = index
        seen.insert(id)
    }

    var nextIndex = orderedIDs.count
    let remaining = categories
        .filter { !seen.contains($0.id) }
        .sorted { lhs, rhs in
            if lhs.sortOrder == rhs.sortOrder {
                return lhs.createdAt < rhs.createdAt
            }
            return lhs.sortOrder < rhs.sortOrder
        }

    for category in remaining {
        category.sortOrder = nextIndex
        nextIndex += 1
    }

    normalizeSortOrder(for: categories)
    try context.save()
}

private func normalizeSortOrder(for categories: [ConversationPersistenceModel.PhraseCategory]) {
    let sorted = categories.sorted { lhs, rhs in
        categorySortComparator(lhs, rhs)
    }

    for (index, category) in sorted.enumerated() {
        category.sortOrder = index
    }
}

private func needsSequentialSortOrder(_ categories: [ConversationPersistenceModel.PhraseCategory]) -> Bool {
    guard !categories.isEmpty else { return false }
    if categories.count == 1 {
        return categories[0].sortOrder != 0
    }

    let sorted = categories.sorted(by: categorySortComparator)
    for (index, category) in sorted.enumerated() where category.sortOrder != index {
        return true
    }
    return false
}

private extension ConversationEntity.PhraseCategory.Icon.Color {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

private func nextSortOrder(in context: ModelContext) throws -> Int {
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

private func categorySortComparator(
    _ lhs: ConversationPersistenceModel.PhraseCategory,
    _ rhs: ConversationPersistenceModel.PhraseCategory
) -> Bool {
    if lhs.sortOrder == rhs.sortOrder {
        return lhs.createdAt < rhs.createdAt
    }
    return lhs.sortOrder < rhs.sortOrder
}

extension UserDefaults: @unchecked @retroactive Sendable {}
