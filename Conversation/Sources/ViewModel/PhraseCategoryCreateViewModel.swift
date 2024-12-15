//
//  PhraseCategoryCreateViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

import Foundation
import Dependencies
import ConversationEntity
import ConversationDependency
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
        do {
            try phraseCategoryRepository.create(.init(id: .init(),
                                                      createdAt: .now,
                                                      metadata: .init(name: categoryName,
                                                                      icon: .init(name: iconName, color: iconColor)),
                                                      phrases: []))
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
