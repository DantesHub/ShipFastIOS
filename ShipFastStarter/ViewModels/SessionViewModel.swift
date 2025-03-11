//
//  SessionViewModel.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 3/11/25.
//

import Foundation
import SwiftUI

class SessionViewModel: ObservableObject {
    // Timer state
    @Published var minutes: Int = 25
    @Published var seconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var selectedTomo: TomoModel? = nil
    
    // Session timer
    private var timer: Timer?
    
    // Start the timer
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    // Stop the timer
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    // Reset the timer
    func resetTimer() {
        stopTimer()
        minutes = 25
        seconds = 0
    }
    
    // Update timer each second
    private func updateTimer() {
        if seconds > 0 {
            seconds -= 1
        } else {
            if minutes > 0 {
                minutes -= 1
                seconds = 59
            } else {
                // Timer has completed
                stopTimer()
                completeSession()
            }
        }
    }
    
    // Set custom time for the session
    func setTime(minutes: Int) {
        self.minutes = minutes
        self.seconds = 0
    }
    
    // Format time for display (e.g., "25:00")
    func formattedTime() -> String {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Called when session completes
    private func completeSession() {
        // Calculate rewards based on session duration
        // Add code to update user's coins, EXP, etc.
    }
    
    // Select a Tomo for the session
    func selectTomo(_ tomo: TomoModel) {
        self.selectedTomo = tomo
    }
}
