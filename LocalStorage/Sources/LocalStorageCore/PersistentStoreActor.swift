import SwiftData

@ModelActor
public actor PersistentStoreActor {
    public static let shared = PersistentStoreActor(modelContainer: ModelContainer.appContainer)

    public func withContext<T>(_ operation: @Sendable (ModelContext) throws -> T) async rethrows -> T {
        try operation(modelContext)
    }
}
