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
    
    let scheduler = NotificationSettings()
    var identifier : String = ""
    let notificationCenter = UNUserNotificationCenter.current()
    static let shared = ReminderController()
    private init() {}
    var entries = [PickupReturnModel]()
    var sections: [[PickupReturnModel]] { [Return, Pickup] }
    var Return: [PickupReturnModel] = []
    var Pickup: [PickupReturnModel] = []
    
    func sendNotification(title: String, message: String, date: Date, identifier: String) {
        
        notificationCenter.getNotificationSettings { (settings) in

            DispatchQueue.main.async
            { [self] in
                let title = title
                let message = message
                let date = date
                
                if(settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message

                    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                    self.notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                        return
                    }
                }
                //else
//                {
//                    let ac = UIAlertController(title: "Enable reminders?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
//                    let goToSettings = UIAlertAction(title: "Settings", style: .default)
//                    { (_) in
//                        guard let setttingsURL = URL(string: UIApplication.openSettingsURLString)
//                        else
//                        {
//                            return
//                        }
//
//                        if(UIApplication.shared.canOpenURL(setttingsURL))
//                        {
//                            UIApplication.shared.open(setttingsURL) { (_) in}
//                        }
//                    }
//                    ac.addAction(goToSettings)
//                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
//                    //self.present(ac, animated: true)
//                }
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
        scheduler.removeScheduledNotification(for: entry)
    }
}
    


