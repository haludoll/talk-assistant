//
//  PhraseCategoryCreateViewModel.swift
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
package final class PhraseCategoryCreateViewModel {
    public var categoryName = ""
    public var iconName = "house.fill"
    public var iconColor: Color = .blue

    @ObservationIgnored
    @Dependency(\.phraseCategoryRepository) private var phraseCategoryRepository

    package init() {}

    package func create() {
        Task {
            do {
                let aggregate = PhraseCategoryAggregate(
                    id: .init(),
                    createdAt: .now,
                    name: categoryName,
                    icon: .init(systemName: iconName, color: .init(color: iconColor)),
                    phrases: []
                )
                try await phraseCategoryRepository.saveCategory(aggregate)
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
