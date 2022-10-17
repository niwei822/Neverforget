//
//  PickupReturnModel.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import Foundation

struct PickupReturnModel: Equatable {
    var storeName: String
    var itemTitle: String?
    var dueDate: Date
    var remindDay: String
    var remindHour: String
    var remindMinute: String
    var notes: String?
    var options: String
    var timestamp: String
}
