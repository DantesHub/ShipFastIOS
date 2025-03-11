//
//  ContentView.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color(.primaryBackground).edgesIgnoringSafeArea(.all)
                switch mainVM.currentPage {
                case .onboarding:
                    OnboardingScreen()
                case .home:
                    HomeScreen()
                case .stats:
                    StatsScreen()
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ContentView()
        // .modelContainer(for: Item.self, inMemory: true)
}
