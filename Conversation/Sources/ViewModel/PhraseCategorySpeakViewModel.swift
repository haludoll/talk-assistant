//
//  PhraseCategorySpeakViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/12/16.
//

import Foundation
import Dependencies
import ConversationEntity
import FirebaseCrashlytics

@Observable
@MainActor
package final class PhraseCategorySpeakViewModel {
    public private(set) var phraseCategories: [PhraseCategory] = []
    public var selectedPhraseCategory: PhraseCategory?

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func fetchPhraseCategories() {
        do {
            phraseCategories = try phraseCategoryRepository.fetchAll()
            selectedPhraseCategory = phraseCategories.first
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
