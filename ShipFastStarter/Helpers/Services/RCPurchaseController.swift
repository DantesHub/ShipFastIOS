

import SuperwallKit
import Foundation
import UIKit
import RevenueCat
import StoreKit
import Mixpanel


final class RCPurchaseController: PurchaseController, ObservableObject {
    static let shared = RCPurchaseController()
    @Published var wentPro = false
    @Published var mainVM: MainViewModel?

    // Private initializer to prevent creating instances directly
     init() {}
  // MARK: Sync Subscription Status
  /// Makes sure that Superwall knows the customers subscription status by
  /// changing `Superwall.shared.subscriptionStatus`
  func syncSubscriptionStatus() {
    assert(Purchases.isConfigured, "You must configure RevenueCat before calling this method.")
    Task {
      for await customerInfo in Purchases.shared.customerInfoStream {
        // Gets called whenever new CustomerInfo is available
        let hasActiveSubscription = !customerInfo.entitlements.active.isEmpty
        if hasActiveSubscription {
            print("revenuecat has an active")
          Superwall.shared.subscriptionStatus = .active
        } else {
            print("revenuecat has no active")
          Superwall.shared.subscriptionStatus = .inactive
        }
      }
    }
  }

  // MARK: Handle Purchases
  /// Makes a purchase with RevenueCat and returns its result. This gets called when
  /// someone tries to purchase a product on one of your paywalls.
  func purchase(product: SKProduct) async -> PurchaseResult {
    do {
      // This must be initialized before initiating the purchase.
      let purchaseDate = Date()
      let storeProduct = RevenueCat.StoreProduct(sk1Product: product)
      let revenueCatResult = try await Purchases.shared.purchase(product: storeProduct)
      if revenueCatResult.userCancelled {
          print("user cancelled inside superwall")
          Analytics.shared.logActual(event: "SubPricingView: Cancelled \(product.productIdentifier)", parameters: [
              "price": product.price,
              "cancelled": product.productIdentifier
          ])
          mainVM?.showHalfOff = true
          UserDefaults.standard.setValue(true, forKey: "pricingClickX")
        return .cancelled
      } else {
        if let transaction = revenueCatResult.transaction,
           purchaseDate > transaction.purchaseDate {
          return .restored
        } else {
            print("purchased")
            
            let userProperties: [String: Any] = [
                "isPro": true,
                // Add other properties as needed
            ]
            
            let userId = UserDefaults.standard.string(forKey: Constants.userId) ?? ""
            Mixpanel.mainInstance().people.set(properties: [
                "isPro": true
                // Add other properties as needed
            ])
//            
//            if let mainVM = self.mainVM, let outfitVM = self.outfitVM, let scanVM = self.scanVM, let chatStore = self.chatStore {
//                if !outfitVM.showScanning && !scanVM.showScanning {
//                    print("bing bing muli")
//                    
//                    UserDefaults.standard.setValue(true, forKey: "purchasedScan")
//                    //                                                                NotificationManager.shared.appLaunched(mainVM: mainVM)
//                    scanVM.showPricing = false
//                    mainVM.justWentPro = true
//                    mainVM.isPro = true
//                    scanVM.showResults = true
//                    
//                    scanVM.purchasedScan = true
//                    mainVM.showPricing = false
//                    if outfitVM.showOnlyFit {
//                        Task {
//                            scanVM.loadingText = "Re-scanning Your Outfit"
//                            outfitVM.showScanning = true
//                            outfitVM.cycleThroughImports(chatStore:chatStore, mainVM: mainVM)
//                        }
//                    } else {
//                        Task {
//                            scanVM.loadingText = "Re-scanning facial features"
//                            scanVM.showScanning = true
//                            await scanVM.createProfileScan(chatStore: chatStore, outfitVM: outfitVM, mainVM: mainVM)
//                        }
//                    }
//                }
//                
//                Analytics.shared.logActual(event: "SubPricingView: Successfully Unlocked", parameters: ["product": product.productIdentifier, "price": product.price])
//            }
            
            
            
            Mixpanel.mainInstance().people.increment(property: "Total Revenue", by: Double(truncating: product.price))
            Analytics.shared.logActual(event: "SubPricingView: Succesfully Unlocked", parameters: [
                "price": product.price,
                "product": product.productIdentifier,
            ])
            
          return .purchased
        }
      }
    } catch let error as ErrorCode {
      if error == .paymentPendingError {
        return .pending
      } else {
        return .failed(error)
      }
    } catch {
      return .failed(error)
    }
  }

  // MARK: Handle Restores
  /// Makes a restore with RevenueCat and returns `.restored`, unless an error is thrown.
  /// This gets called when someone tries to restore purchases on one of your paywalls.
  func restorePurchases() async -> RestorationResult {
    do {
      _ = try await Purchases.shared.restorePurchases()
      return .restored
    } catch let error {
      return .failed(error)
    }
  }
}
