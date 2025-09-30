import Foundation
import Testing
import SwiftData
@testable import LocalStorageCore
import ConversationPersistenceModel

@Suite
struct SchemasMigrationTests {
    @Test
    func willMigrateFromV1_0_0toV1_1_0_assignsSequentialSortOrder() throws {
        let schema = Schema(versionedSchema: Schemas.V1_1_0.self)
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let categories: [ConversationPersistenceModel.PhraseCategory] = [
            .init(id: UUID(), createdAt: Date(timeIntervalSince1970: 10), metadata: .init(name: "First", icon: .init(name: "a", color: .init(red: 0, green: 0, blue: 0))), sortOrder: 42, phrases: []),
            .init(id: UUID(), createdAt: Date(timeIntervalSince1970: 5), metadata: .init(name: "Second", icon: .init(name: "b", color: .init(red: 0, green: 0, blue: 0))), sortOrder: 42, phrases: [])
        ]

        for category in categories {
            context.insert(category)
        }
        try context.save()

        try Schemas.didMigrateFromV1_0_0toV1_1_0(context)

        let descriptor = FetchDescriptor<ConversationPersistenceModel.PhraseCategory>(
            sortBy: [
                .init(\.createdAt, order: .forward)
            ]
        )
        let migrated = try context.fetch(descriptor)

        #expect(migrated.map(\.sortOrder) == [0, 1])
    }
}
