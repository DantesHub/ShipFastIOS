//
//  ShipFastStarterApp.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import SwiftUI
import SwiftData
import SwiftData
import Mixpanel
import AppsFlyerLib
import RevenueCat
import SuperwallKit

@main
struct ShipFastStarterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var mainVM: MainViewModel = MainViewModel()
    
    init() {
      setup()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainVM)
        }
        .modelContainer(sharedModelContainer)
    }
    
    func setup() {
        let secondLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
        
        if !secondLaunch {
            UserDefaults.standard.setValue(true, forKey: "firstLaunch")
            let userId = UUID().uuidString
            UserDefaults.standard.setValue(userId, forKey: Constants.userId)
        }
        
        let userId = UserDefaults.standard.string(forKey: Constants.userId) ?? ""
        
        Purchases.configure(withAPIKey: "", appUserID: userId)
     
        Superwall.configure(apiKey: "pk_88a4283fb120960bd9daaf8180061db015bbeeb303396abb", purchaseController: RCPurchaseController.shared)
        Superwall.shared.identify(userId: userId)
        
        AppsFlyerLib.shared().appsFlyerDevKey = ""
        AppsFlyerLib.shared().appleAppID = ""
        AppsFlyerLib.shared().customerUserID = userId
        AppsFlyerLib.shared().logEvent("App Started", withValues: [:])
        AppsFlyerLib.shared().isDebug = false
        AppsFlyerLib.shared().start()
        
        
        Mixpanel.initialize(token: "", trackAutomaticEvents: false)
        Mixpanel.mainInstance().track(event: "App Start")
        Mixpanel.mainInstance().identify(distinctId: userId)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
}
