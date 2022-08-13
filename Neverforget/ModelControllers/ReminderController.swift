//
//  ReminderController.swift
//  Neverforget
//
//  Created by cecily li on 7/18/22.
//

import Foundation

class ReminderController {
    
    let scheduler = NotificationSettings()
    static let shared = ReminderController()
    private init() {}
    var entries = [PickupReturnModel]()
    var sections: [[PickupReturnModel]] { [Return, Pickup] }
    var Return: [PickupReturnModel] = []
    var Pickup: [PickupReturnModel] = []
    
    func deleteEntry(_ entry: PickupReturnModel) {
        if let index = Return.firstIndex(of: entry) {
            Return.remove(at: index)
        } else if let index = Pickup.firstIndex(of: entry) {
            Pickup.remove(at: index)
        }
        Service.deleteEntryFromDatebase(timestamp: entry.timestamp)
        scheduler.removeScheduledNotification(for: entry)
    }
    
}
    


