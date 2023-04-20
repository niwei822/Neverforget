//
//  ReminderController.swift
//  Neverforget
//
//  Created by cecily li on 7/18/22.
//

import Foundation
import UIKit
import UserNotifications

class ReminderController {
    
    // MARK: - Properties
        
        var identifier: String = ""

        private let notificationCenter = UNUserNotificationCenter.current()
        
        static let shared = ReminderController()
        
        private init() {}
    
    func sendNotificationByDate(title: String, message: String, date: Date, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        // extracts dateComponents from datepicker
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        self.notificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendNotificationByFrequency(title: String, message: String, remindDay: String, remindHour: String, remindMinute: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        let t_interval = Double(remindDay)! * 24 * 3600 + Double(remindHour)! * 3600 + Double(remindMinute)! * 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: t_interval, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        self.notificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func removeScheduledNotification(for entry: PickupReturnModel) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [entry.timestamp])
    }
}



