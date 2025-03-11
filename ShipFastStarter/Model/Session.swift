//
//  Untitled.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 3/11/25.
//

import Foundation
import SwiftData

@Model
final class FocusSessionRecord {
    var id: String
    var startTime: Date
    var endTime: Date?
    var duration: Int // in minutes
    var wasCompleted: Bool
    var expEarned: Int
    var coinsEarned: Int
    var tomoId: String?
    var participantIds: [String]
    var tag: String?
    var userId: String?

    // Add this computed property to match Firestore timestamp format in your Expo project
    var startTimeSeconds: Int {
        return Int(startTime.timeIntervalSince1970)
    }

    // Add this computed property to match Firestore timestamp format in your Expo project
    var endTimeSeconds: Int? {
        guard let endTime = endTime else { return nil }
        return Int(endTime.timeIntervalSince1970)
    }

    init(id: String = UUID().uuidString,
         startTime: Date = Date(),
         duration: Int,
         tomoId: String? = nil,
         tag: String? = nil,
         userId: String? = nil) {
        self.id = id
        self.startTime = startTime
        self.duration = duration
        self.wasCompleted = false
        self.expEarned = 0
        self.coinsEarned = 0
        self.tomoId = tomoId
        self.participantIds = []
        self.tag = tag
        self.userId = userId
    }

    func completeSession() {
        self.endTime = Date()
        self.wasCompleted = true

        // Calculate rewards
        self.expEarned = max(1, self.duration)
        self.coinsEarned = max(1, self.duration)

        // Apply multiplier for group sessions
        let multiplier = min(3, max(1, self.participantIds.count + 1))
        self.expEarned *= multiplier
    }
}
