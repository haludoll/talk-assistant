import ConversationDependency
import ConversationEntity
import Dependencies
import FirebaseCrashlytics
import Foundation

@Observable
@MainActor
package final class PhraseAddViewModel {
    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func add(_ text: String, to categoryID: PhraseCategory.ID) {
        Task {
            do {
                let newPhrase = PhraseCategory.Phrase(
                    id: .init(),
                    createdAt: .now,
                    value: text,
                    categoryID: categoryID
                )
                try await phraseCategoryRepository.appendPhrase(categoryID, newPhrase)
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}

@Observable
@MainActor
package final class PhraseDeleteViewModel {
    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func delete(_ phraseID: PhraseCategory.Phrase.ID, in categoryID: PhraseCategory.ID) {
        Task {
            do {
                try await phraseCategoryRepository.removePhrase(categoryID, phraseID)
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
