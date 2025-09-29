//
//  ModelContainer.swift
//  LocalStorage
//
//  Created by haludoll on 2024/12/08.
//

@preconcurrency import SwiftData

extension ModelContainer {
    private static let schema = Schema(versionedSchema: Schemas.V1_1_0.self)
    private static let configuration = ModelConfiguration(schema: schema)

    public static let appContainer = try! ModelContainer(
        for: schema,
        migrationPlan: MigrationPlan.self,
        configurations: [configuration]
    )
}
