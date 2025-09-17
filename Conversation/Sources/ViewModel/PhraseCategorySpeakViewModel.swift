//
//  PhraseCategorySpeakViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/12/16.
//

import Foundation
import ConversationDependency
import ConversationEntity
import Dependencies
import FirebaseCrashlytics

@Observable
@MainActor
package final class PhraseCategorySpeakViewModel {
    public private(set) var phraseCategories: [PhraseCategory] = []
    public var selectedPhraseCategory: PhraseCategory?

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func fetchAll() async {
        do {
            phraseCategories = try await phraseCategoryRepository.listCategories()
            selectedPhraseCategory = phraseCategories.first
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }

    package func createDefault() async {
        do {
            try await phraseCategoryRepository.createDefaultCategoryIfNeeded()
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
