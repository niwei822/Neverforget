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
    
    var identifier : String = ""
    let notificationCenter = UNUserNotificationCenter.current()
    static let shared = ReminderController()
    private init() {}
    var entries = [PickupReturnModel]()
    var sections: [[PickupReturnModel]] { [Return, Pickup] }
    var Return: [PickupReturnModel] = []
    var Pickup: [PickupReturnModel] = []
    
    func sendNotificationByDate(title: String, message: String, date: Date, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        // extracts dateComponents from datepicker
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        self.notificationCenter.add(request) { (error) in
            if(error != nil)
            {
                print("Error " + error.debugDescription)
                return
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
        self.notificationCenter.add(request) { (error) in
            if(error != nil)
            {
                print("Error " + error.debugDescription)
                return
            }
        }
    }
    
    func deleteEntry(_ entry: PickupReturnModel) {
        if let index = Return.firstIndex(of: entry) {
            Return.remove(at: index)
        } else if let index = Pickup.firstIndex(of: entry) {
            Pickup.remove(at: index)
        }
        UserFBController.deleteEntryFromDatebase(timestamp: entry.timestamp)
        removeScheduledNotification(for: entry)
    }
    
    func removeScheduledNotification(for entry: PickupReturnModel) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [entry.timestamp])
    }
}



