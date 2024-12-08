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

    package func add(phrase value: String, to category: PhraseCategory) {
        do {
            try phraseRepository.create(.init(id: .init(), value: value, category: category))
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
