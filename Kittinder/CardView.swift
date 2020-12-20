// Created 20/12/2020

import SwiftUI

struct CardView: View {
    let image: UIImage

    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .blur(radius: 25.0, opaque: true)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        .cornerRadius(15)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(image: UIImage(named: "a94")!)
            .frame(width: 300, height: 500)
    }
}
