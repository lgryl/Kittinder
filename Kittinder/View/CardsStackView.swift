// Created 29/12/2020

import SwiftUI

struct CardsStackView: View {
    @ObservedObject var viewModel: ViewModel
    @GestureState private var dragState = DragState.inactive

    var body: some View {
        ForEach(viewModel.images, id: \.self) { image in
            CardView(image: image)
                .overlay(
                    ZStack {
                        Image(systemName: "heart.circle")
                            .foregroundColor(Color(.systemRed))
                            .font(.system(size: 120))
                            .opacity(isTop(image) && dragState.translation.width > 80 ? 0.9 : 0)
                        Image(systemName: "heart.slash.circle")
                            .foregroundColor(Color(.systemRed))
                            .font(.system(size: 120))
                            .opacity(isTop(image) && dragState.translation.width < -80 ? 0.9 : 0)
                    }
                )
                .zIndex(isTop(image) ? 1 : 0)
                .offset(x: isTop(image) ? dragState.translation.width : 0)
                .scaleEffect(isTop(image) && dragState.isDragging ? 0.95 : 1.0)
                .rotationEffect(.degrees(isTop(image) ? Double(dragState.translation.width / 20) : 0))
                .transition(dragState.translation.width > 0 ? .slideTrailingBottom : .slideLeadingBottom)
                .animation(.easeInOut)
                .gesture(
                    LongPressGesture(minimumDuration: 0.01)
                        .sequenced(before: DragGesture())
                        .updating(self.$dragState, body: { (value, state, transaction) in
                            switch value {
                            case .first(true):
                                state = .pressing
                            case .second(true, let drag):
                                state = .dragging(translation: drag?.translation ?? .zero)
                            default:
                                break
                            }
                        })
                        .onEnded({ value in
                            guard case .second(true, let drag?) = value else {
                                return
                            }
                            if drag.translation.width > 80 {
                                removeCard(like: true)
                            } else if drag.translation.width < -80 {
                                removeCard(like: false)
                            }
                        })
                )
        }
    }

    private func isTop(_ image: UIImage) -> Bool {
        viewModel.images.first == image
    }

    private func removeCard(like: Bool) {
        viewModel.removeTopCard(like: like)
    }
}

struct CardsStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardsStackView(viewModel: ViewModel())
    }
}
