//
//  AppDelegate.swift
//  talk-assistant
//
//  Created by haludoll on 2024/10/21.
//

import UIKit
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        #else
        FirebaseApp.configure()
        #endif
        return true
    }
}
