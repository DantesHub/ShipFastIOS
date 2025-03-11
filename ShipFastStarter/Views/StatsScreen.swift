//
//  StatsScreen.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 3/11/25.
//

import SwiftUI
import Charts

struct StatsScreen: View {
    @StateObject var viewModel = StatsViewModel()
    @State private var timeFrame: TimeFrame = .day
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Time frame selector with proper styling
                HStack(spacing: 0) {
                    ForEach(TimeFrame.allCases, id: \.self) { frame in
                        Button(action: { timeFrame = frame }) {
                            Text(frame.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(timeFrame == frame ? Color(hex: "#FFD700") : .clear)
                                .foregroundColor(.black)
                        }
                    }
                }
                .background(
                    Capsule()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                )
                .overlay(
                    Capsule()
                        .stroke(.black, lineWidth: 1)
                )
                
                // Days of the week with correct styling
                HStack(spacing: 8) {
                    ForEach(0..<7) { index in
                        let isSelected = index == 2 // Make W (14) selected
                        VStack {
                            Text(["M", "T", "W", "T", "F", "S", "S"][index])
                                .font(.system(size: 12))
                            Text("\(12 + index)") // Start from 12 to match the design
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(width: 36, height: 36)
                        .background(isSelected ? Color.black : .clear)
                        .foregroundColor(isSelected ? .white : .black)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 1)
                        )
                    }
                }
                
                // Screentime section - using refactored BoxCard
                VStack(alignment: .leading, spacing: 8) {
                    Text("Screentime")
                        .font(.system(size: 24, weight: .bold))
                    
                    BoxCard(padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today, September 14")
                                .foregroundColor(.gray)
                            Text("3h 15m")
                                .font(.system(size: 32, weight: .bold))
                            
                            Text("Screentime per hour")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                            
                            // Chart placeholder
                            VStack(alignment: .leading) {
                                HStack(alignment: .bottom, spacing: 8) {
                                    ForEach(0..<12) { _ in
                                        Rectangle()
                                            .fill(Color.blue.opacity(0.3))
                                            .frame(width: 20, height: CGFloat.random(in: 20...100))
                                    }
                                }
                                
                                HStack {
                                    Text("12AM")
                                    Spacer()
                                    Text("6AM")
                                    Spacer()
                                    Text("12PM")
                                    Spacer()
                                    Text("6PM")
                                }
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            }
                            .padding(.vertical)
                        }
                    }
                }
                
                // Most Used section - using refactored BoxCard
                VStack(alignment: .leading, spacing: 8) {
                    Text("Most Used")
                        .font(.system(size: 24, weight: .bold))
                    
                    BoxCard {
                        VStack(spacing: 0) {
                            ForEach(0..<3) { i in
                                HStack(spacing: 12) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(8)
                                    
                                    Text("Messages")
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                    
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(height: 4)
                                    
                                    Text("2h 20m")
                                        .font(.system(size: 14))
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                
                                if i < 2 {
                                    Divider()
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
        .background(Color(hex: "#F5F5F5"))
    }
    
    // MARK: - Time Frame Selector
    private var timeFrameSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimeFrame.allCases, id: \.self) { frame in
                Button(action: { timeFrame = frame }) {
                    Text(frame.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(timeFrame == frame ? Color.yellow : Color.white)
                        .foregroundColor(.black)
                }
                .clipShape(Capsule())
            }
        }
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 2))
    }
    
    // MARK: - Days of Week Selector
    private var daysOfWeekSelector: some View {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let dates = viewModel.getMockWeekDates() // Changed to use mock dates for UI
        
        return HStack(spacing: 16) {
            ForEach(0..<7, id: \.self) { index in
                let isSelected = index == 1 // Making Tuesday selected as shown in screenshot
                Button(action: { /* Selection logic */ }) {
                    VStack(spacing: 4) {
                        Text(days[index])
                            .font(.system(size: 14))
                        Text("\(10 + index)")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(width: 40, height: 40)
                    .background(isSelected ? Color.black : Color.white)
                    .foregroundColor(isSelected ? .white : .black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                }
            }
        }
    }
    
    // MARK: - Screen Time Section
    private var screenTimeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Screentime")
                .font(.system(size: 24, weight: .bold))
            
            // Screentime card - simplified to match screenshot
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .frame(height: 8),
                    alignment: .bottom
                )
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 4))
                .primaryShadow()
        }
    }
    
    // MARK: - Most Used Section
    private var mostUsedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Most Used")
                .font(.system(size: 24, weight: .bold))
            
            VStack(spacing: 0) {
                ForEach(viewModel.mostUsedApps.indices, id: \.self) { index in
                    let app = viewModel.mostUsedApps[index]
                    appUsageRow(app: app)
                    
                    if index < viewModel.mostUsedApps.count - 1 {
                        Divider()
                            .background(Color.black.opacity(0.1))
                    }
                }
            }
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 2))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .primaryShadow()
        }
    }
    
    private func appUsageRow(app: AppUsage) -> some View {
        HStack(spacing: 12) {
            // App icon - dark square on gray background
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 24, height: 24)
            }
            
            // App name - showing "Messages" in multiple lines as in screenshot
            Text(app.name)
                .font(.system(size: 16, weight: .medium))
                .lineLimit(1)
            
            Spacer()
            
            // Usage bar
            Rectangle()
                .fill(Color.blue)
                .frame(width: 200, height: 8)
                .clipShape(Capsule())
                .padding(.trailing, 8)
            
            // Time text
            Text(app.formattedUsageTime)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 70, alignment: .trailing)
        }
        .padding(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
    }
}

enum TimeFrame: String, CaseIterable {
    case month = "Month"
    case week = "Week"
    case day = "Day"
}

struct StatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        StatsScreen()
            .environmentObject(StatsViewModel())
    }
}
