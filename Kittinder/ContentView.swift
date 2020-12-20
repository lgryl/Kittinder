// Created 20/12/2020

import SwiftUI

struct ContentView: View {
    @GestureState private var dragState = DragState.inactive

    var images = ["a94", "ad9"].compactMap{ UIImage(named: $0) }
    var body: some View {
        ZStack {
            ForEach(images, id: \.self) { image in
                CardView(image: image)
                    .overlay(
                        ZStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color(.systemRed))
                                .font(.system(size: 75))
                                .opacity(isTop(image) && dragState.translation.width > 80 ? 0.8 : 0)
                            Image(systemName: "heart.slash.fill")
                                .foregroundColor(Color(.systemRed))
                                .font(.system(size: 75))
                                .opacity(isTop(image) && dragState.translation.width < -80 ? 0.8 : 0)
                        }
                    )
                    .zIndex(isTop(image) ? 1 : 0)
                    .offset(x: isTop(image) ? dragState.translation.width : 0)
                    .rotationEffect(.degrees(isTop(image) ? Double(dragState.translation.width / 20) : 0))
                    .animation(.easeInOut)
                    .gesture(DragGesture()
                                .updating(self.$dragState, body: { (value, state, transaction) in
                                    state = .dragging(translation: value.translation)
                                }))

            }
        }
        .padding()
    }

    private func isTop(_ image: UIImage) -> Bool {
        images.first == image
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
