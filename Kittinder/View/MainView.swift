// Created 20/12/2020

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isSharePresented = false

    var body: some View {
        VStack {
            Text("Kittinder")
                .font(.system(.title, design: .rounded))
                .bold()
                .foregroundColor(.primary)
            ZStack {
                if viewModel.images.count <= 1 {
                    NoCardsView(viewModel: viewModel)
                }
                CardsStackView(viewModel: viewModel)
                    .padding(.vertical, 10)
            }
            Button(action: {
                shareTopImage()
            }, label: {
                Text("Share".uppercased())
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(Color(.systemBackground))
                    .padding(.horizontal, 35)
                    .padding(.vertical, 15)
                    .background(Color("ButtonBackground"))
                    .cornerRadius(10)
                    .opacity(viewModel.images.isEmpty ? 0 : 1)
            })
        }
        .padding()
        .onAppear {
            viewModel.loadMoreCats()
        }
        .sheet(isPresented: $isSharePresented, content: {
            ActivityViewController(activityItems: [viewModel.images[0]], applicationActivities: nil)
        })
    }

    private func shareTopImage() {
        isSharePresented = true

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: ViewModel())
    }
}
