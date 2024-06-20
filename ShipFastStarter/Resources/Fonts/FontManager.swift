//
//  FontManager.swift
//  FitCheck
//
//  Created by Dante Kim on 11/2/23.
//

import SwiftUI

struct FontManager {
    
    static func defaultFont(size: CGFloat) -> Font {
        return Font.custom("ClashDisplay-Regular", size: size)
    }
    
    static func heading1(size: CGFloat = 24) -> Font {
        return Font.custom("ClashDisplay-Bold", size: size)
    }
    
    static func body1(size: CGFloat = 16) -> Font {
        return Font.custom("ClashDisplay-Medium", size: size)
    }
    
    static func clash(type: ClashType, size: FontSize) -> Font {
        switch type {
        case .regular: return Font.custom("ClashDisplay-Regular", size: size.rawValue)
        case .medium:  return Font.custom("ClashDisplay-Medium", size: size.rawValue)
        case .semibold:  return Font.custom("ClashDisplay-Semibold", size: size.rawValue)
        case .bold:  return Font.custom("ClashDisplay-Bold", size: size.rawValue)
        case .light: return Font.custom("ClashDisplay-Light", size: size.rawValue)
        case .extraLight: return Font.custom("ClashDisplay-Extralight", size: size.rawValue)
        }
    }
    // Add other custom styles as needed
}


enum ClashType {
    case regular
    case medium
    case semibold
    case bold
    case light
    case extraLight
}

enum FontSize: CGFloat {
    case h1Big = 40
    case h1 = 32
    case h2 = 24
    case h3 = 22
    case h3p1 = 20
    case p2 = 16
    case p3 = 14
    case p4 = 12
    case title = 48
    case huge = 56
    case titleHuge = 72
}

extension View {
    
    func defaultFont(size: CGFloat) -> some View {
        self.font(FontManager.defaultFont(size: size))
    }
    
    func heading1() -> some View {
        self.font(FontManager.heading1())
    }
    
    func body1() -> some View {
        self.font(FontManager.body1())
    }
    func clash(type: ClashType, size: FontSize) -> some View {
        self.font(FontManager.clash(type: type, size: size))
    }
    
    // Add other custom modifiers as needed
}
