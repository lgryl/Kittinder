// Created 20/12/2020

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if viewModel.images.isEmpty {
                NoCardsView(viewModel: viewModel)
            }
            CardsStackView(viewModel: viewModel)
        }
        .padding()
        .onAppear {
            viewModel.loadMoreImages()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: ViewModel())
    }
}
