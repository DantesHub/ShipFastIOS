//
//  Numbers.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import Foundation


extension Int {
  func formatNumberWithHashAndPadding() -> String {
    return String(format: "#%03d", self)
  }
  func isInt(between firstNumber: Int, and secondNumber: Int) -> Bool {
    return (firstNumber...secondNumber).contains(self)
  }
}


extension Double {
    func roundToTwoDecimalPoints() -> Double {
        return (self * 100).rounded() / 100
    }
    
    func roundedString(to digits: Int) -> String {
        String(format: "%.\(digits)f", self)
    }
}


