//
//  MainViewModel.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var currentPage: Page = .home
    @Published var isPro = false
    @Published var showHalfOff = false 
    
}

enum Page: String {
    case home = "Home"
    case onboarding = "Onboarding"
}
