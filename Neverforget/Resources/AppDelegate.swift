//
//  AppDelegate.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configureUserNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    private func configureUserNotifications() {
        //declare AppDelegate is the delegate
      UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - UNUserNotificationCenterDelegate
//asks the delegate how to handle a notification when the app is in the foreground
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler(.banner)
  }
}


