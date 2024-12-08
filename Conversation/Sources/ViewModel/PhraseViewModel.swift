//
//  PhraseViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/12/08.
//

import Foundation
import Dependencies
import ConversationEntity
import ConversationDependency
import FirebaseCrashlytics
import SwiftUI

@Observable
@MainActor
package final class PhraseAddViewModel {
    @ObservationIgnored
    @Dependency(\.phraseRepository) private var phraseRepository

    package init() {}

    package func add(_ text: String, to category: PhraseCategory) {
        do {
            try phraseRepository.create(Phrase(id: .init(), createdAt: .now, value: text, category: category))
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}

@Observable
@MainActor
package final class PhraseDeleteViewModel {
    @ObservationIgnored
    @Dependency(\.phraseRepository) private var phraseRepository

    package init() {}

    package func delete(_ phrase: Phrase) {
        do {
            try phraseRepository.delete(phrase)
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
