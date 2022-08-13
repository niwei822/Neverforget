//
//  NotificationSettings.swift
//  Neverforget
//
//  Created by cecily li on 7/20/22.
//
import UIKit
import Foundation
import UserNotifications

class NotificationSettings {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func removeScheduledNotification(for entry: PickupReturnModel) {
      UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [entry.timestamp])
    }
}
