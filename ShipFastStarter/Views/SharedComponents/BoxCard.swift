import SwiftUI

struct BoxCard<Content: View>: View {
    // Remove size property
    let children: Content
    var padding: EdgeInsets? = nil
    
    // Updated init without size parameter
    init(@ViewBuilder content: () -> Content) {
        self.children = content()
    }
    
    // Add an initializer with padding
    init(padding: EdgeInsets, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.children = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(Color.primaryBackground)
                .primaryShadow()
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .stroke(.black, lineWidth: 4)
            VStack {
                children
            }
            // Fixed the optional padding issue by using conditional modifier
            .padding(padding ?? EdgeInsets()) // Use empty EdgeInsets if nil
            .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
        }
        // Height is determined by content size
    }
}

enum BoxSize: CGFloat  {
    case small = 6.5
    case big = 3.5
    case option = 14
    case tile = 4.5
}
