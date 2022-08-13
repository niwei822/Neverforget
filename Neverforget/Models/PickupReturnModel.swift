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
    var notes: String?
    var options: String
    var timestamp: String
}
