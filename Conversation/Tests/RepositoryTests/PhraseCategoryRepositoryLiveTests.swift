import Testing
import SwiftData
@testable import ConversationRepository
import ConversationEntity
import ConversationPersistenceModel
import LocalStorageCore
import Foundation
import XCTest

@Suite
struct PhraseCategoryRepositoryLiveTests {
    @Test(.harnessTrait)
    func createCategoryAssignsSequentialSortOrder() async throws {
        let harness = try HarnessTrait.harness()

        let first = harness.makeCategory(name: "Home")
        let second = harness.makeCategory(name: "Health")

        try await harness.repository.createCategory(first)
        try await harness.repository.createCategory(second)

        let categories = try await harness.repository.listCategories()
        #expect(categories.map(\.name) == ["Home", "Health"])
        #expect(categories.map(\.sortOrder) == [0, 1])
    }

    @Test(.harnessTrait)
    func reorderCategoriesUpdatesPersistedOrder() async throws {
        let harness = try HarnessTrait.harness()

        let first = harness.makeCategory(name: "A")
        let second = harness.makeCategory(name: "B")
        try await harness.repository.createCategory(first)
        try await harness.repository.createCategory(second)

        let initial = try await harness.repository.listCategories()
        #expect(initial.map(\.id) == [first.id, second.id])

        try await harness.repository.reorderCategories([second.id, first.id])
        let reordered = try await harness.repository.listCategories()

        #expect(reordered.map(\.id) == [second.id, first.id])
        #expect(reordered.map(\.sortOrder) == [0, 1])
    }

    @Test(.harnessTrait)
    func listCategoriesReturnsPersistedSortOrder() async throws {
        let harness = try HarnessTrait.harness()

        let first = harness.makeCategory(name: "Category 1")
        let second = harness.makeCategory(name: "Category 2")
        try await harness.repository.createCategory(first)
        try await harness.repository.createCategory(second)

        try await harness.store.withContext { context in
            let models = try context.fetch(FetchDescriptor<ConversationPersistenceModel.PhraseCategory>())
            guard models.count == 2 else { return }
            models[0].sortOrder = 10
            models[1].sortOrder = 10
            try context.save()
        }

        let categories = try await harness.repository.listCategories()
        #expect(categories.map(\.sortOrder) == [10, 10])
    }

    @Test(.harnessTrait)
    func reorderCategoriesKeepsUnspecifiedCategoriesAppendedInExistingOrder() async throws {
        let harness = try HarnessTrait.harness()

        let first = harness.makeCategory(name: "First")
        let second = harness.makeCategory(name: "Second")
        let third = harness.makeCategory(name: "Third")

        try await harness.repository.createCategory(first)
        try await harness.repository.createCategory(second)
        try await harness.repository.createCategory(third)

        try await harness.repository.reorderCategories([second.id])

        let categories = try await harness.repository.listCategories()
        #expect(categories.map(\.id) == [second.id, first.id, third.id])
        #expect(categories.map(\.sortOrder) == [0, 1, 2])
    }

    @Test(.harnessTrait)
    func updateCategoryKeepsExistingSortOrder() async throws {
        let harness = try HarnessTrait.harness()

        let first = harness.makeCategory(name: "A")
        let second = harness.makeCategory(name: "B")

        try await harness.repository.createCategory(first)
        try await harness.repository.createCategory(second)

        try await harness.repository.reorderCategories([second.id, first.id])

        var editedFirst = first
        editedFirst.name = "Edited"

        try await harness.repository.updateCategory(editedFirst)

        let categories = try await harness.repository.listCategories()
        #expect(categories.map(\.id) == [second.id, first.id])
        #expect(categories.map(\.name) == ["B", "Edited"])
        #expect(categories.map(\.sortOrder) == [0, 1])
    }

    @Test(.harnessTrait)
    func nextSortOrderReturnsNextIndex() async throws {
        let harness = try HarnessTrait.harness()

        try await harness.repository.createCategory(harness.makeCategory(name: "One"))
        try await harness.repository.createCategory(harness.makeCategory(name: "Two"))

        let next = try await harness.store.withContext { context -> Int in
            try PhraseCategoryRepository.nextSortOrder(in: context)
        }

        #expect(next == 2)
    }

    @Test(.harnessTrait)
    func applyCategoryOrderDirectlyReordersAndAppends() async throws {
        let harness = try HarnessTrait.harness()

        let first = harness.makeCategory(name: "A")
        let second = harness.makeCategory(name: "B")
        let third = harness.makeCategory(name: "C")

        try await harness.repository.createCategory(first)
        try await harness.repository.createCategory(second)
        try await harness.repository.createCategory(third)

        try await harness.store.withContext { context in
            try PhraseCategoryRepository.applyCategoryOrder([third.id, first.id], in: context)
        }

        let categories = try await harness.repository.listCategories()
        #expect(categories.map(\.id) == [third.id, first.id, second.id])
        #expect(categories.map(\.sortOrder) == [0, 1, 2])
    }
}

private struct HarnessTrait: TestTrait, TestScoping, Sendable {
    func provideScope(
        for test: Test,
        testCase: Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        let harness = try TestHarness()
        defer { harness.tearDown() }

        try await HarnessTaskLocal.$current.withValue(harness) {
            try await function()
        }
    }

    static func harness() throws -> TestHarness {
        try #require(HarnessTaskLocal.current)
    }
}

private enum HarnessTaskLocal {
    @TaskLocal static var current: TestHarness?
}

private final class TestHarness: @unchecked Sendable {
    let container: ModelContainer
    let store: PersistentStoreActor
    let userDefaultsSuiteName: String
    let userDefaults: UserDefaults
    let repository: PhraseCategoryRepository

    init() throws {
        let schema = Schema(versionedSchema: Schemas.V1_1_0.self)
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        container = try ModelContainer(
            for: schema,
            migrationPlan: MigrationPlan.self,
            configurations: [configuration]
        )
        store = PersistentStoreActor(modelContainer: container)

        userDefaultsSuiteName = "phrase-category-repository-tests-\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: userDefaultsSuiteName) else {
            throw XCTSkip("Unable to create user defaults suite: \(userDefaultsSuiteName)")
        }
        defaults.removePersistentDomain(forName: userDefaultsSuiteName)
        userDefaults = defaults

        repository = PhraseCategoryRepository.live(store: store, userDefaults: userDefaults)
    }

    func tearDown() {
        userDefaults.removePersistentDomain(forName: userDefaultsSuiteName)
    }

    func makeCategory(name: String) -> ConversationEntity.PhraseCategory {
        ConversationEntity.PhraseCategory(
            id: UUID(),
            createdAt: Date(),
            name: name,
            icon: .init(
                systemName: "folder.fill",
                color: .init(red: 0.5, green: 0.5, blue: 0.5)
            ),
            sortOrder: 0,
            phrases: []
        )
    }
}

private extension Trait where Self == HarnessTrait {
    static var harnessTrait: Self {
        Self()
    }
}
