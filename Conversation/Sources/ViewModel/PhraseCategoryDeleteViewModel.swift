//
//  PhraseCategoryDeleteViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import Foundation
import Dependencies
import ConversationEntity
import ConversationDependency
import FirebaseCrashlytics

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
