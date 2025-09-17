//
//  PhraseCategoryListViewModel.swift
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
package final class PhraseCategoryListViewModel {
    public private(set) var phraseCategories: [PhraseCategory] = []

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func fetchAll() {
        Task {
            do {
                phraseCategories = try await phraseCategoryRepository.listCategories()
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
