//
//  SharedComponents.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import Foundation
import SwiftUI

struct SharedComponents {
    static func exampleButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}
