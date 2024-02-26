//
//  Item.swift
//  RestaurantApp
//
//  Created by Luis Felipe Dussán 2 on 26/02/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
