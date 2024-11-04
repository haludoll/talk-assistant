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

extension DependencyValues {
    package var phraseCategoryRepository: PhraseCategoryRepository {
        get { self[PhraseCategoryRepository.self] }
        set { self[PhraseCategoryRepository.self] = newValue }
    }
}

