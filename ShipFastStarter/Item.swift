//
//  Item.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
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
