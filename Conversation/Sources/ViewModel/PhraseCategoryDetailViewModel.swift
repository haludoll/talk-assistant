//
//  PhraseCategoryDetailViewModel.swift
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
package final class PhraseCategoryDetailViewModel {
    public var phraseCategory: PhraseCategoryAggregate?

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func fetch(for id: PhraseCategoryAggregate.ID) {
        Task {
            do {
                phraseCategory = try await phraseCategoryRepository.findCategory(id)
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
