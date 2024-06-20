import Foundation
import SwiftUI

extension Color {
  
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
  
  static var label: Color {
    return Color(UIColor.label)
  }
  
  static var secondaryLabel: Color {
    return Color(UIColor.secondaryLabel)
  }
  
  static var tertiaryLabel: Color {
    return Color(UIColor.tertiaryLabel)
  }
  
  static var quaternaryLabel: Color {
    return Color(UIColor.quaternaryLabel)
  }
  
  static var systemFill: Color {
    return Color(UIColor.systemFill)
  }
  
  static var secondarySystemFill: Color {
    return Color(UIColor.secondarySystemFill)
  }
  
  static var tertiarySystemFill: Color {
    return Color(UIColor.tertiarySystemFill)
  }
  
  static var quaternarySystemFill: Color {
    return Color(UIColor.quaternarySystemFill)
  }
  
  static var systemBackground: Color {
    return Color(UIColor.systemBackground)
  }
  
  static var secondarySystemBackground: Color {
    return Color(UIColor.secondarySystemBackground)
  }
  
  static var tertiarySystemBackground: Color {
    return Color(UIColor.tertiarySystemBackground)
  }
  
  static var systemGroupedBackground: Color {
    return Color(UIColor.systemGroupedBackground)
  }
  
  static var secondarySystemGroupedBackground: Color {
    return Color(UIColor.secondarySystemGroupedBackground)
  }
  
  static var tertiarySystemGroupedBackground: Color {
    return Color(UIColor.tertiarySystemGroupedBackground)
  }
  
  static var systemRed: Color {
    return Color(UIColor.systemRed)
  }
  
  static var systemBlue: Color {
    return Color(UIColor.systemBlue)
  }
  
  static var systemPink: Color {
    return Color(UIColor.systemPink)
  }
  
  static var systemTeal: Color {
    return Color(UIColor.systemTeal)
  }
  
  static var systemGreen: Color {
    return Color(UIColor.systemGreen)
  }
  
  static var systemIndigo: Color {
    return Color(UIColor.systemIndigo)
  }
  
  static var systemOrange: Color {
    return Color(UIColor.systemOrange)
  }
  
  static var systemPurple: Color {
    return Color(UIColor.systemPurple)
  }
  
  static var systemYellow: Color {
    return Color(UIColor.systemYellow)
  }
  
  static var systemGray: Color {
    return Color(UIColor.systemGray)
  }
  
  static var systemGray2: Color {
    return Color(UIColor.systemGray2)
  }
  
  static var systemGray3: Color {
    return Color(UIColor.systemGray3)
  }
  
  static var systemGray4: Color {
    return Color(UIColor.systemGray4)
  }
  
  static var systemGray5: Color {
    return Color(UIColor.systemGray5)
  }
  
  static var systemGray6: Color {
    return Color(UIColor.systemGray6)
  }
  
}
