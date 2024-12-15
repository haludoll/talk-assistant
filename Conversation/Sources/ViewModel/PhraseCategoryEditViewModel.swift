//
//  PhraseCategoryEditViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import Foundation
import Dependencies
import ConversationEntity
import ConversationDependency
import FirebaseCrashlytics
import struct SwiftUI.Color

@Observable
@MainActor
package final class PhraseCategoryEditViewModel {
    public var categoryName: String
    public var iconName: String
    public var iconColor: Color

    private let phraseCategory: PhraseCategory

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init(phraseCategory: PhraseCategory) {
        self.phraseCategory = phraseCategory
        self.categoryName = phraseCategory.metadata.name
        self.iconName = phraseCategory.metadata.icon.name
        self.iconColor = phraseCategory.metadata.icon.color
    }

    package func edit() {
        do {
            try phraseCategoryRepository.edit(.init(id: phraseCategory.id,
                                                    createdAt: phraseCategory.createdAt,
                                                    metadata: .init(name: categoryName,
                                                                    icon: .init(name: iconName, color: iconColor)),
                                                    phrases: phraseCategory.phrases))
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
