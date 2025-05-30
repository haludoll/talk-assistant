//
//  ConversationDependency.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import Dependencies
import ConversationEntity
import ConversationRepository

extension PhraseCategoryRepository: DependencyKey {
    package static let liveValue = PhraseCategoryRepository.live()
}

extension PhraseRepository: DependencyKey {
    package static let liveValue = PhraseRepository.live()
}

extension PhraseCategoryRepository: TestDependencyKey {
    package static let previewValue = Self(
        fetch: { _ in .init(id: .init(0), createdAt: .now, metadata: .init(name: "home", icon: .init(name: "house.fill", color: .blue)), phrases: [.init(id: .init(), createdAt: .now, value: "Hello")]) },
        fetchAll: { [.init(id: .init(0), createdAt: .now, metadata: .init(name: "home", icon: .init(name: "house.fill", color: .blue)), phrases: [.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello"),.init(id: .init(), createdAt: .now, value: "Hello")]),
                     .init(id: .init(2), createdAt: .now, metadata: .init(name: "Health", icon: .init(name: "heart.fill", color: .pink)), phrases: [])] },
        create: { _ in },
        delete: { _ in },
        edit: { _ in }
    )
}

extension DependencyValues {
    package var phraseCategoryRepository: PhraseCategoryRepository {
        get { self[PhraseCategoryRepository.self] }
        set { self[PhraseCategoryRepository.self] = newValue }
    }

    package var phraseRepository: PhraseRepository {
        get { self[PhraseRepository.self] }
        set { self[PhraseRepository.self] = newValue }
    }
}

