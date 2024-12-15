//
//  PhraseCategoryDetailViewModel.swift
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
