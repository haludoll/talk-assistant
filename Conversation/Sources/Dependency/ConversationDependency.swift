//
//  ConversationDependency.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import ConversationEntity
import ConversationRepository
import Dependencies

extension PhraseCategoryRepository: DependencyKey {
    package static let liveValue = PhraseCategoryRepository.live()
}

extension PhraseCategoryRepository: TestDependencyKey {
    package static let previewValue = Self(
        findCategory: { id in
            guard let category = previewCategories.first(where: { $0.id == id }) else {
                return previewCategories[0]
            }
            return category
        },
        listCategories: {
            previewCategories
        },
        saveCategory: { _ in },
        deleteCategory: { _ in },
        createDefaultCategoryIfNeeded: {},
        appendPhrase: { _, _ in },
        removePhrase: { _, _ in }
    )

    private static let previewCategories: [PhraseCategoryAggregate] = [
        .init(
            id: .init(0),
            createdAt: .now,
            name: "home",
            icon: .init(systemName: "house.fill", color: .init(red: 0.0, green: 0.478, blue: 1.0)),
            phrases: [
                .init(id: .init(), createdAt: .now, value: "Hello", categoryID: .init(0))
            ]
        ),
        .init(
            id: .init(2),
            createdAt: .now,
            name: "Health",
            icon: .init(systemName: "heart.fill", color: .init(red: 1.0, green: 0.2, blue: 0.5)),
            phrases: []
        )
    ]
}

extension DependencyValues {
    package var phraseCategoryRepository: PhraseCategoryRepository {
        get { self[PhraseCategoryRepository.self] }
        set { self[PhraseCategoryRepository.self] = newValue }
    }
}
