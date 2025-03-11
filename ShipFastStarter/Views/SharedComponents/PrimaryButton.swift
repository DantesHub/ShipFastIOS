//
//  PrimaryButton.swift
//  Halo
//
//  Created by Dante Kim on 9/2/23.
//

import SwiftUI

struct PrimaryButton: View {
    var img: Image?
    var title: String = "Continue2"
    var isDisabled:Bool
    @State private var opacity: Double = 1
    var action: () -> Void
    
    init(img: Image? = nil, title: String = "Continue2", action: @escaping () -> Void, isDisabled: Bool = false) {
         self.img = img
         self.title = title
         self.action = action
         self.isDisabled = isDisabled
     }
    
    var body: some View {
    
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.primary)
                    .frame(height: 50)
                    .scaleEffect(opacity == 1 ? 1 : 0.95)
                    .opacity(opacity)
                HStack {
                    Spacer()
                    Text(title)
                        .foregroundColor(.white)
//                        .font(Font.prompt(.medium, size: 20))
                    Spacer()
                    if let img = img {
                        img
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .bold()
                    }
                }.padding(.horizontal, 32)
            }
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.opacity = 0.7
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring()) {
                        self.opacity = 1
                        self.action()
                    }
                }
            }
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.5 : 1)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton( action: {})
            .padding()
    }
}
