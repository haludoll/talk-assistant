//
//  PhraseCategoryViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import Foundation
import Dependencies
import ConversationEntity
import ConversationDependency
import FirebaseCrashlytics
import SwiftUI

@Observable
@MainActor
package final class PhraseCategoryViewModel {
    public var phraseCategories: [PhraseCategory] = []

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func fetchAll() {
        do {
            phraseCategories = try phraseCategoryRepository.fetchAll()
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }

    package func delete(_ phraseCategory: PhraseCategory) {
        do {
            try phraseCategoryRepository.delete(phraseCategory)
            phraseCategories.removeAll(where: { $0.id == phraseCategory.id })
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}

@Observable
@MainActor
package final class PhraseCategoryCreateViewModel {
    public var categoryName = ""
    public var iconName = "house.fill"
    public var iconColor: Color = .blue

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func create() {
        do {
            try phraseCategoryRepository.create(.init(id: .init(),
                                                      metadata: .init(name: categoryName,
                                                                      icon: .init(name: iconName, color: iconColor)),
                                                      phrases: []))
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}

@Observable
@MainActor
package final class PhraseCategoryEditViewModel {
    public var categoryName: String
    public var iconName: String
    public var iconColor: Color

    private let id: PhraseCategory.ID
    private let phrases: [Phrase]

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init(phraseCategory: PhraseCategory) {
        self.id = phraseCategory.id
        self.phrases = phraseCategory.phrases
        self.categoryName = phraseCategory.metadata.name
        self.iconName = phraseCategory.metadata.icon.name
        self.iconColor = phraseCategory.metadata.icon.color
    }

    package func edit() {
        do {
            try phraseCategoryRepository.edit(.init(id: id,
                                                    metadata: .init(name: categoryName,
                                                                    icon: .init(name: iconName, color: iconColor)),
                                                    phrases: phrases))
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
