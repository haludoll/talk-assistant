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
            await loadCategories()
        }
    }

    package func moveCategory(from source: IndexSet, to destination: Int) {
        var updated = phraseCategories
        updated.move(fromOffsets: source, toOffset: destination)
        phraseCategories = updated

        Task {
            do {
                let orderedIDs = updated.map(\.id)
                try await phraseCategoryRepository.reorderCategories(orderedIDs)
            } catch {
                Crashlytics.crashlytics().record(error: error)
                await loadCategories()
            }
        }
    }

    private func loadCategories() async {
        do {
            phraseCategories = try await phraseCategoryRepository.listCategories()
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
