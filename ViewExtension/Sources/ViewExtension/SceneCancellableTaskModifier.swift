//
//  SceneCancellableTaskModifier.swift
//  ViewExtension
//
//  Created by haludoll on 2024/10/23.
//

import SwiftUI

struct SceneCancellableTaskModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    let action: @Sendable () async -> Void
    func body(content: Content) -> some View {
        content
            .task(id: scenePhase) {
                guard scenePhase == .active else { return }
                await action()
            }
    }
}

public extension View {
    func sceneCancellableTask(_ action: @escaping @Sendable () async -> Void) -> some View {
        modifier(SceneCancellableTaskModifier(action: action))
    }
}
