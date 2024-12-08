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

//FIXME: When using the observation framework, the view may not be updated. (Detected when returning from the details screen with the category updated)
@MainActor
package final class PhraseCategoryListViewModel: ObservableObject {
    @Published public var phraseCategories: [PhraseCategory] = []

    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func fetchAll() {
        do {
            phraseCategories = try phraseCategoryRepository.fetchAll()
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}

@Observable
@MainActor
package final class PhraseCategoryDetailViewModel {
    public var phraseCategory: PhraseCategory?

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func fetch(for id: PhraseCategory.ID) {
        do {
            phraseCategory = try phraseCategoryRepository.fetch(id)
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
                                                      createdAt: .now,
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

@Observable
@MainActor
package final class PhraseCategoryDeleteViewModel {
    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func delete(_ phraseCategory: PhraseCategory) {
        do {
            try phraseCategoryRepository.delete(phraseCategory)
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
