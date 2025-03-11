//
//  MainViewModel.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import Foundation
import SwiftData
import UserNotifications

class MainViewModel: ObservableObject {
    @Published var currentPage: Page = .home
    @Published var isPro = false
    @Published var showHalfOff = false
    
    // User data
    @Published var currentUser: UserModel?
    @Published var isAuthenticated = false
    
    // Focus session data
    @Published var isInFocusSession = false
    @Published var currentSession: FocusSessionRecord?
    @Published var selectedTomo: TomoModel?
    @Published var sessionDuration = 25 // Default 25 minutes
    @Published var remainingTime: TimeInterval = 0
    @Published var sessionTimer: Timer?
    @Published var isGroupSession = false
    @Published var groupParticipants: [UserModel] = []
    
    // Tomo and egg collection
    @Published var userTomos: [TomoModel] = []
    @Published var userEggs: [EggModel] = []
    
    // Store data
    @Published var coins = 0
    
    // Initialize user data
    func initializeUserData() {
        // Check if user exists in SwiftData
        // If not, create a new guest user
        let userId = UserDefaults.standard.string(forKey: Constants.userId) ?? UUID().uuidString
        
        // TODO: Fetch user from SwiftData or create new one
        // For now, we'll create a placeholder
        let newUser = UserModel(id: userId)
        self.currentUser = newUser
        self.coins = newUser.coins
    }
    
    // Focus Session Methods
    func startFocusSession(duration: Int, tomo: TomoModel?, isGroup: Bool = false, participants: [UserModel] = []) {
        guard !isInFocusSession else { return }
        
        sessionDuration = duration
        selectedTomo = tomo
        isGroupSession = isGroup
        groupParticipants = participants
        
        let session = FocusSessionRecord(duration: duration, tomoId: tomo?.id)
        if isGroup {
            session.participantIds = participants.map { $0.id }
        }
        
        currentSession = session
        remainingTime = TimeInterval(duration * 60)
        
        // Start the timer
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        
        isInFocusSession = true
        
        // Schedule notification for when session ends
        scheduleEndSessionNotification(duration: duration)
    }
    
    private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            completeSession()
        }
    }
    
    func completeSession() {
        guard isInFocusSession, let session = currentSession else { return }
        
        sessionTimer?.invalidate()
        sessionTimer = nil
        
        session.completeSession()
        
        // Update user data
        if let user = currentUser {
            user.coins += session.coinsEarned
            user.totalMinutesFocused += session.duration
            user.sessionHistory.append(session)
            
            // Update selected Tomo
            if let tomo = selectedTomo, let tomoIndex = user.tomos.firstIndex(where: { $0.id == tomo.id }) {
                user.tomos[tomoIndex].currentExp += session.expEarned
                user.tomos[tomoIndex].totalExp += session.expEarned
                user.tomos[tomoIndex].totalMinutesFocused += session.duration
                user.tomos[tomoIndex].sessionHistory.append(session)
                
                // Check for level up
                checkForLevelUp(tomo: &user.tomos[tomoIndex])
            }
            
            // Update published properties
            self.coins = user.coins
            self.userTomos = user.tomos
        }
        
        isInFocusSession = false
        currentSession = nil
        
        // Remove scheduled notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func interruptSession() {
        guard isInFocusSession else { return }
        
        sessionTimer?.invalidate()
        sessionTimer = nil
        
        if let session = currentSession {
            session.wasCompleted = false
            session.endTime = Date()
            
            // Add to history but with no rewards
            if let user = currentUser {
                user.sessionHistory.append(session)
            }
        }
        
        isInFocusSession = false
        currentSession = nil
        
        // Remove scheduled notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func checkForLevelUp(tomo: inout TomoModel) {
        while tomo.currentExp >= tomo.requiredExpForNextLevel {
            tomo.level += 1
            tomo.currentExp -= tomo.requiredExpForNextLevel
            tomo.requiredExpForNextLevel = 200 * tomo.level * tomo.level
        }
    }
    
    // Notification Methods
    private func scheduleEndSessionNotification(duration: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Focus Session Complete!"
        content.body = "Great job! Your focus session has ended."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(duration * 60), repeats: false)
        let request = UNNotificationRequest(identifier: "focusSessionEnd", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Store Methods
    func purchaseMysteryBox(isGolden: Bool = false) -> EggType? {
        let cost = isGolden ? 3000 : 500
        
        guard let user = currentUser, user.coins >= cost else { return nil }
        
        // Deduct coins
        user.coins -= cost
        self.coins = user.coins
        
        // Determine egg type
        let eggType: EggType
        
        if isGolden {
            eggType = .legendary
        } else {
            // Regular mystery box with drop rates
            let randomValue = Int.random(in: 1...100)
            
            if randomValue <= 5 {
                eggType = .legendary
            } else if randomValue <= 15 {
                eggType = .epic
            } else if randomValue <= 25 {
                eggType = .superRare
            } else if randomValue <= 50 {
                eggType = .rare
            } else {
                eggType = .common
            }
        }
        
        // Create egg and add to user's collection
        let newEgg = EggModel(type: eggType)
        user.eggs.append(newEgg)
        self.userEggs = user.eggs
        
        return eggType
    }
    
  
    // Authentication Methods
    func authenticateUser(phoneNumber: String) {
        // In a real app, this would integrate with Firebase Phone Auth
        // For now, we'll simulate authentication
        
        if let user = currentUser {
            user.phoneNumber = phoneNumber
            user.isGuest = false
            self.isAuthenticated = true
        }
    }
}

enum Page: String {
    case home = "Home"
    case onboarding = "Onboarding"
    case stats = "Stats"
//    case focusSession = "FocusSession"
//    case tomodex = "Tomodex"
//    case incubation = "Incubation"
//    case shop = "Shop"
//    case friends = "Friends"
//    case profile = "Profile"
}
