//
//  PhraseCategoryEditViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import Foundation
import ConversationDependency
import ConversationEntity
import Dependencies
import FirebaseCrashlytics
import struct SwiftUI.Color

@Observable
@MainActor
package final class PhraseCategoryEditViewModel {
    public var categoryName: String
    public var iconName: String
    public var iconColor: Color

    private var phraseCategory: PhraseCategory

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init(phraseCategory: PhraseCategory) {
        self.phraseCategory = phraseCategory
        self.categoryName = phraseCategory.name
        self.iconName = phraseCategory.icon.systemName
        self.iconColor = phraseCategory.icon.color.toColor()
    }

    package func edit() {
        Task {
            do {
                phraseCategory.name = categoryName
                phraseCategory.icon = .init(systemName: iconName, color: .init(color: iconColor))
                try await phraseCategoryRepository.saveCategory(phraseCategory)
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
