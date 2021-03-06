// Created 29/12/2020

import SwiftUI

struct NoCardsView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        if viewModel.isFetching {
            ProgressView()
        } else {
            VStack {
                Text("Error loading cats")
                Button(action: {
                    viewModel.loadMoreCats()
                }, label: {
                    Text("Try again")
                })
            }
        }
    }
}


struct NoCardsView_Previews: PreviewProvider {
    static var previews: some View {
        NoCardsView(viewModel: ViewModel())
    }
}
