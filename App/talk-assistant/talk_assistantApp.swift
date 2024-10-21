//
//  talk_assistantApp.swift
//  talk-assistant
//
//  Created by haludoll on 2024/10/05.
//

import SwiftUI
import Root
import FirebaseAnalytics

@main
struct talk_assistantApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.colorScheme) private var colorScheme

    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    // WORKAROUND: FirebaseAnalytics automatic collection events will not be collected unless any one event is manually submitted.
                    //             Therefore, send the colour scheme event first for now.
                    Analytics.logEvent("color_scheme", parameters: [AnalyticsParameterItemVariant : colorScheme])
                }
        }
    }
}
