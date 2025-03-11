//
//  OptionButton.swift
//  Halo
//
//  Created by Dante Kim on 9/2/23.
//

import SwiftUI

struct OptionButton: View {
    var title: String = ""
    var action: () -> Void
    @State private var tapped = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(Color.primaryBackground)
                .drawingGroup()
                .shadow(color: Color.black, radius: 0, x: tapped ? 0 : 8, y: tapped ? 0 : 8)
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .stroke(.black, lineWidth: 4)
            Text(title)
                .foregroundColor(Color.primary)
        }.frame(height: 60)
            .offset(x: tapped ? 6 : 0, y: tapped ? 6 : 0)
        .onTapGesture {
            withAnimation {
                tapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation() {
                        self.tapped = false
                        self.action()
                    }
                }
            }
        }
    }
}

struct OptionButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionButton(action: {})
    }
}
