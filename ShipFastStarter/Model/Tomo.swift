//
//  Tomo.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 3/11/25.
//

import Foundation
import SwiftData

// Define TomoRarity to match your Expo project
enum TomoRarity: String, Codable {
    case common
    case rare
    case superRare
    case epic
    case legendary
}

// Mapping the old TomoType to new TomoRarity
enum TomoType: String, Codable {
    case common
    case rare
    case superRare
    case epic
    case legendary
    
    var toRarity: TomoRarity {
        switch self {
        case .common: return .common
        case .rare: return .rare
        case .superRare: return .superRare
        case .epic: return .epic
        case .legendary: return .legendary
        }
    }
}

@Model
final class TomoModel {
    var id: String
    var name: String
    var type: TomoType
    var level: Int
    var currentExp: Int
    var totalExp: Int
    var requiredExpForNextLevel: Int
    var totalMinutesFocused: Int
    var acquisitionDate: Date
    var sessionHistory: [FocusSessionRecord]
    
    // Add a property to match your Expo model's session history format
    var sessionHistoryDates: [SessionHistoryEntry] {
        return sessionHistory.compactMap { session in
            if let endTime = session.endTime, session.wasCompleted {
                return SessionHistoryEntry(date: endTime.formatted(date: .numeric, time: .omitted), duration: session.duration)
            }
            return nil
        }
    }
    
    // Computed property to map to your Expo project's rarity
    var rarity: TomoRarity {
        return type.toRarity
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         type: TomoType,
         level: Int = 1,
         currentExp: Int = 0,
         totalExp: Int = 0,
         totalMinutesFocused: Int = 0,
         acquisitionDate: Date = Date()) {
        self.id = id
        self.name = name
        self.type = type
        self.level = level
        self.currentExp = currentExp
        self.totalExp = totalExp
        self.requiredExpForNextLevel = 200 * level * level
        self.totalMinutesFocused = totalMinutesFocused
        self.acquisitionDate = acquisitionDate
        self.sessionHistory = []
    }
}

// Session history entry to match your Expo model
struct SessionHistoryEntry: Codable {
    var date: String
    var duration: Int
}

enum EggType: String, Codable {
    case common
    case rare
    case superRare
    case epic
    case legendary
    
    var incubationDays: Int {
        switch self {
        case .common: return 1
        case .rare: return 2
        case .superRare: return 3
        case .epic: return 5
        case .legendary: return 7
        }
    }
}

// Add this to match your egg model
@Model
final class EggModel {
    var id: String
    var type: EggType
    var incubationStartDate: Date?
    
    init(id: String = UUID().uuidString, type: EggType) {
        self.id = id
        self.type = type
        self.incubationStartDate = nil
    }
}
