//
//  PhraseCategoryListViewModel.swift
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
package final class PhraseCategoryListViewModel {
    public private(set) var phraseCategories: [PhraseCategory] = []

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
}
