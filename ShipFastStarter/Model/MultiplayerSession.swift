//
//  MultiplayerSession.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 3/11/25.
//

import Foundation
import SwiftData

// Define the status enum for multiplayer sessions
enum MultiplayerSessionStatus: String, Codable {
    case waiting
    case in_progress = "in_progress"
    case completed
    case abandoned
}

// Define the participant structure for multiplayer sessions
struct Participant: Identifiable, Codable {
    var id: String { userId }
    var userId: String
    var tomoId: String
    var tag: String
}

@Model
final class MultiplayerSession {
    var id: String
    var hostId: String
    var participants: [Participant]
    var duration: Int  // in minutes
    var status: String
    var startedTime: Date?
    var endedTime: Date?
    var createdAt: Date
    var updatedAt: Date
    
    // Convert to/from MultiplayerSessionStatus enum
    var sessionStatus: MultiplayerSessionStatus {
        get {
            return MultiplayerSessionStatus(rawValue: status) ?? .waiting
        }
        set {
            status = newValue.rawValue
        }
    }
    
    init(id: String = UUID().uuidString,
         hostId: String,
         duration: Int,
         participants: [Participant] = []) {
        self.id = id
        self.hostId = hostId
        self.duration = duration
        self.participants = participants
        self.status = MultiplayerSessionStatus.waiting.rawValue
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // Start the session
    func startSession() {
        self.startedTime = Date()
        self.sessionStatus = .in_progress
        self.updatedAt = Date()
    }
    
    // Complete the session
    func completeSession() {
        self.endedTime = Date()
        self.sessionStatus = .completed
        self.updatedAt = Date()
    }
    
    // Abandon the session
    func abandonSession() {
        self.endedTime = Date()
        self.sessionStatus = .abandoned
        self.updatedAt = Date()
    }
    
    // Add a participant to the session
    func addParticipant(_ participant: Participant) {
        if !participants.contains(where: { $0.userId == participant.userId }) {
            participants.append(participant)
            updatedAt = Date()
        }
    }
    
    // Remove a participant from the session
    func removeParticipant(userId: String) {
        participants.removeAll(where: { $0.userId == userId })
        updatedAt = Date()
    }
}
