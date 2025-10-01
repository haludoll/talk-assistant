//
//  Schema.swift
//  LocalStorage
//
//  Created by haludoll on 2025/09/29.
//

import Foundation
import SwiftData
import ConversationPersistenceModel

public enum Schemas {
    public enum V1_1_0: VersionedSchema {
        public static var versionIdentifier: Schema.Version { Schema.Version(1, 1, 0) }
        public static var models: [any PersistentModel.Type] {
            [ConversationPersistenceModel.PhraseCategory.self, ConversationPersistenceModel.Phrase.self]
        }
    }

    enum V1_0_0: VersionedSchema {
        static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }
        static var models: [any PersistentModel.Type] {
            [PhraseCategory.self, Phrase.self]
        }

        @Model
        final class PhraseCategory {
            @Attribute(.unique) var id: UUID
            var createdAt: Date
            var metadata: ConversationPersistenceModel.PhraseCategory.Metadata
            @Relationship(deleteRule: .cascade, inverse: \Phrase.category) var phrases: [Phrase] = []

            init(id: UUID, createdAt: Date, metadata: ConversationPersistenceModel.PhraseCategory.Metadata, phrases: [Phrase]) {
                self.id = id
                self.createdAt = createdAt
                self.metadata = metadata
                self.phrases = phrases
            }
        }

        @Model
        final class Phrase {
            @Attribute(.unique) var id: UUID
            var createdAt: Date
            var value: String
            var category: PhraseCategory?

            init(id: UUID, createdAt: Date, value: String, category: PhraseCategory? = nil) {
                self.id = id
                self.createdAt = createdAt
                self.value = value
                self.category = category
            }
        }
    }
}

extension Schemas {
    static func didMigrateFromV1_0_0toV1_1_0(_ context: ModelContext) throws {
        let descriptor = FetchDescriptor<ConversationPersistenceModel.PhraseCategory>(
            sortBy: [
                .init(\.createdAt, order: .forward)
            ]
        )
        let categories = try context.fetch(descriptor)
        for (index, category) in categories.enumerated() {
            category.sortOrder = index
        }
        if context.hasChanges {
            try context.save()
        }
    }
}

public enum MigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] {
        [Schemas.V1_0_0.self, Schemas.V1_1_0.self]
    }

    public static var stages: [MigrationStage] {
        [
            .custom(
                fromVersion: Schemas.V1_0_0.self,
                toVersion: Schemas.V1_1_0.self,
                willMigrate: nil,
                didMigrate: { context in
                    try Schemas.didMigrateFromV1_0_0toV1_1_0(context)
                }
            )
        ]
    }
}
