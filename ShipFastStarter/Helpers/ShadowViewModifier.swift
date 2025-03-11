//
//  ShadowViewModifier.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 3/11/25.
//

import SwiftUI

struct ShadowViewModifier: ViewModifier {
    var darkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func body(content: Content) -> some View {
        content
         
            .drawingGroup()
            .shadow(color: Color.black, radius: 0, x: 8, y: 8)
    }
}


extension View {
    /// Adds a shadow onto this view with the specified `ShadowStyle`
    func primaryShadow(darkMode: Bool = false) -> some View {
        modifier(ShadowViewModifier(darkMode: darkMode))
    }
}


struct SpecificCornerViewModifier: ViewModifier {
    var size: CGSize
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: topLeft)
                    .frame(width: topLeft * 2, height: topLeft * 2)
                    .position(CGPoint(x: topLeft, y: topLeft))
            )
            .overlay(
                RoundedRectangle(cornerRadius: topRight)
                    .frame(width: topRight * 2, height: topRight * 2)
                    .position(CGPoint(x: size.width - topRight, y: topRight))
            )
            .overlay(
                RoundedRectangle(cornerRadius: bottomLeft)
                    .frame(width: bottomLeft * 2, height: bottomLeft * 2)
                    .position(CGPoint(x: bottomLeft, y: size.height - bottomLeft))
            )
            .overlay(
                RoundedRectangle(cornerRadius: bottomRight)
                    .frame(width: bottomRight * 2, height: bottomRight * 2)
                    .position(CGPoint(x: size.width - bottomRight, y: size.height - bottomRight))
            )
            .mask(content)
    }
}

extension View {
    func specificCornerRadius(size: CGSize, topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) -> some View {
        modifier(SpecificCornerViewModifier(size: size, topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight))
    }
}
