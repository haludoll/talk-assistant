//
//  PhraseCategoryDeleteViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import Foundation
import ConversationDependency
import ConversationEntity
import Dependencies
import FirebaseCrashlytics

@Observable
@MainActor
package final class PhraseCategoryDeleteViewModel {
    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func delete(_ phraseCategory: PhraseCategoryAggregate) {
        Task {
            do {
                try await phraseCategoryRepository.deleteCategory(phraseCategory.id)
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
