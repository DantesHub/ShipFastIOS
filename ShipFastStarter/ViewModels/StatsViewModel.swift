//
//  StatsViewModel.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 3/11/25.
//

import Foundation
import SwiftUI

class StatsViewModel: ObservableObject {
    @Published var hourlyScreenTimeData: [HourlyScreenTime] = []
    @Published var mostUsedApps: [AppUsage] = []
    
    init() {
        generateMockData()
    }
    
    func generateMockData() {
        // Generate mock hourly screen time data
        hourlyScreenTimeData = [
            HourlyScreenTime(hour: "12AM", minutes: 5),
            HourlyScreenTime(hour: "1AM", minutes: 15),
            HourlyScreenTime(hour: "2AM", minutes: 30),
            HourlyScreenTime(hour: "3AM", minutes: 20),
            HourlyScreenTime(hour: "4AM", minutes: 5),
            HourlyScreenTime(hour: "5AM", minutes: 0),
            HourlyScreenTime(hour: "6AM", minutes: 0),
            HourlyScreenTime(hour: "7AM", minutes: 0),
            HourlyScreenTime(hour: "8AM", minutes: 0),
            HourlyScreenTime(hour: "9AM", minutes: 0),
            HourlyScreenTime(hour: "10AM", minutes: 0),
            HourlyScreenTime(hour: "11AM", minutes: 5),
            HourlyScreenTime(hour: "12PM", minutes: 15),
            HourlyScreenTime(hour: "1PM", minutes: 25),
            HourlyScreenTime(hour: "2PM", minutes: 30),
            HourlyScreenTime(hour: "3PM", minutes: 15),
            HourlyScreenTime(hour: "4PM", minutes: 10),
            HourlyScreenTime(hour: "5PM", minutes: 5),
            HourlyScreenTime(hour: "6PM", minutes: 0),
            HourlyScreenTime(hour: "7PM", minutes: 10),
            HourlyScreenTime(hour: "8PM", minutes: 5),
            HourlyScreenTime(hour: "9PM", minutes: 0),
            HourlyScreenTime(hour: "10PM", minutes: 0),
            HourlyScreenTime(hour: "11PM", minutes: 0)
        ]
        
        // Generate mock most used apps data
        mostUsedApps = [
            AppUsage(name: "Messages", minutes: 140, percentageOfTotal: 0.8),
            AppUsage(name: "Messages", minutes: 140, percentageOfTotal: 0.8),
            AppUsage(name: "Messages", minutes: 140, percentageOfTotal: 0.8)
        ]
    }
    
    func getCurrentWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let dayOfWeek = calendar.component(.weekday, from: today)
        
        // Calculate the date for Monday of the current week
        let startOfWeek = calendar.date(byAdding: .day, value: 2 - dayOfWeek, to: today) ?? today
        
        // Generate dates for the entire week
        var weekDates: [Date] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                weekDates.append(date)
            }
        }
        
        return weekDates
    }
    
    // Mock week dates to match screenshot (10-16)
    func getMockWeekDates() -> [Date] {
        var weekDates: [Date] = []
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<7 {
            let components = DateComponents(year: 2023, month: 7, day: 10 + i)
            if let date = calendar.date(from: components) {
                weekDates.append(date)
            } else {
                weekDates.append(today) // Fallback
            }
        }
        
        return weekDates
    }
}

// Simple data structure for hourly screen time
struct HourlyScreenTime: Identifiable {
    let id = UUID()
    let hour: String
    let minutes: Double
}

// AppUsage with Equatable conformance
struct AppUsage: Equatable, Identifiable {
    let id = UUID() // Added id for safer iteration
    let name: String
    let minutes: Int
    let percentageOfTotal: Double
    
    var formattedUsageTime: String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
