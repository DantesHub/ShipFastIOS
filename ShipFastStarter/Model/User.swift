//
//  User.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 3/11/25.
//

import Foundation
import SwiftData

// Define Tag type to match your Expo project
struct Tag: Identifiable, Codable {
    var id: String
    var name: String
}

// Define Friend structure
struct Friend: Identifiable, Codable {
    var id: String
    var userId: String
}

// User stats to match your Expo project
struct UserStats: Codable {
    var totalFocusTime: Int
    var totalCoins: Int
    var totalSessions: Int
}

@Model
final class UserModel {
    var id: String
    var phoneNumber: String?
    var name: String?
    var username: String?
    var usernameLower: String?
    var fcmToken: String?
    var isGuest: Bool
    var tomos: [TomoModel]
    var eggs: [EggModel]
    var coins: Int
    var totalMinutesFocused: Int
    var sessionHistory: [FocusSessionRecord]
    var friends: [Friend]
    var tags: [Tag]
    var selectedTag: String?
    var selectedTomo: String?
    
    // Computed property to provide stats in the format of your Expo project
    var stats: UserStats {
        get {
            return UserStats(
                totalFocusTime: totalMinutesFocused,
                totalCoins: coins,
                totalSessions: sessionHistory.filter { $0.wasCompleted }.count
            )
        }
    }
    
    init(id: String = UUID().uuidString) {
        self.id = id
        self.isGuest = true
        self.tomos = []
        self.eggs = []
        self.coins = 0
        self.totalMinutesFocused = 0
        self.sessionHistory = []
        self.friends = []
        self.tags = []
    }
}
