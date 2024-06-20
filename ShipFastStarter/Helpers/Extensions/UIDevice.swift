//
//  UIDevice.swift
//  FitCheck
//
//

import Foundation
import UIKit

extension UIDevice {
    /// Returns `true` if the device has a notch
    static var hasNotch: Bool {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return false }
            
            return window.safeAreaInsets.top > 20
        }
        
        if #available(iOS 11.0, *) {
//            let top = UIApplication.shared.windows[0].safeAreaInsets.top
            let top = UIWindow.current?.safeAreaInsets.top ?? 0
            return top > 20
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
    static var isBottom: Bool {
        let bottom = UIWindow.current?.safeAreaInsets.bottom
        return (bottom ?? 0) > 0
    }
    
    static var isIPad: Bool {
          // Get the device's native screen size
          let screenSize = UIScreen.main.nativeBounds.size
          // Common native resolution width for iPads is greater than 768 points
          return screenSize.width >= 768 * UIScreen.main.nativeScale
      }
    
    static var isSmall: Bool {
        return !UIDevice.hasNotch && !UIDevice.isIPad
    }
    
}
#if canImport(UIKit)
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else {continue}
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
    
    static var size: CGSize {
        if #available(iOS 17, *) {
            return self.current?.bounds.size ?? .zero
        } else {
            return self.main.bounds.size
        }
    }
}
