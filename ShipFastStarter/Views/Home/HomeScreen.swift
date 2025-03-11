//
//  HomeScreen.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var sessionViewModel = SessionViewModel()
    
    var body: some View {
        ZStack {
            // Background GIF - now properly scaled to fill the screen
            Color.black.edgesIgnoringSafeArea(.all) // Black background in case GIF has loading delay
            GIFView(gifName: "tomoBackground")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack {
                // Add some space at the top
                
                // Position timer box in upper part of screen
                Spacer().frame(height: 240)
                
                // Timer container - using BoxCard with minimal padding to make it compact
                BoxCard(padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)) {
                    // Timer content with minimal spacings
                    VStack(spacing: 0) {
                        // Top row with "Lock-in" and button
                        HStack {
                            Text("Lock-in")
                                // Using Silkscreen font for game-like appearance
                                .silkscreen(type: .bold, size: .p2)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            // Start button with blue pill shape
                            Button(action: {
                                if sessionViewModel.isRunning {
                                    // Log debug info when stopping timer
                                    print("DEBUG: Stopping timer at \(sessionViewModel.formattedTime())")
                                    sessionViewModel.stopTimer()
                                } else {
                                    // Log debug info when starting timer
                                    print("DEBUG: Starting new timer session")
                                    sessionViewModel.startTimer()
                                }
                            }) {
                                Text(sessionViewModel.isRunning ? "stop" : "start")
                                    // Using Silkscreen font for button text
                                    .silkscreen(type: .regular, size: .p3)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 5) // Minimal vertical padding
                                    .background(Color.blue)
                                    .cornerRadius(16)
                            }
                        }
                        
                        // Timer display - directly below without extra spacing
                        Text(sessionViewModel.formattedTime())
                            // Using Silkscreen font for timer - larger size for emphasis
                            .silkscreen(type: .bold, size: .h1Big)
                            .foregroundColor(.black)
                    }.frame(height: 100)
                    // No additional padding here - it's already provided to BoxCard
                }
                .frame(height: 100)
//                .frame(width: UIScreen.main.bounds.width * 0.8)
                
                Spacer()
                
                // Space for Tomo at bottom of screen
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 120)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    HomeScreen()
}
