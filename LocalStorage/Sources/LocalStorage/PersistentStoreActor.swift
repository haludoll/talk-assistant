import SwiftData

@ModelActor
public actor PersistentStoreActor {
    public nonisolated static let shared = PersistentStoreActor(modelContainer: ModelContainer.appContainer)
}
