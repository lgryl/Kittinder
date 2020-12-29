// Created 21/12/2020

import UIKit

class ViewModel: ObservableObject {
    @Published private(set) var isFetching = false
    @Published private(set) var images: [UIImage] = []
    private var catsBuffer: [CatData] = []
    private let catsProvider = CatsProvider()
    private let voteService = VoteService()

    func removeTopCard(like: Bool) {
        guard let topCatData = catsBuffer.first else { return }
        print(images)
        print(catsBuffer)
        vote(imageID: topCatData.cat.id, like: like)
        removeTopImageFromBuffers()
        if catsBuffer.count < 5 {
            fetch(numberOfCats: 10)
        }
    }

    private func vote(imageID: String, like: Bool) {
        voteService.vote(imageID: imageID, like: like)
    }

    func loadMoreCats() {
        fetch(numberOfCats: 5)
    }

    private func fetch(numberOfCats: Int) {
        guard !isFetching else { return }
        isFetching = true
        catsProvider.provideCats(numberOfCats: 10) { [weak self] catsData in
            self?.isFetching = false
            self?.catsBuffer.append(contentsOf: catsData)
            self?.updateBuffer()
        }
    }

    private func removeTopImageFromBuffers() {
        if !catsBuffer.isEmpty {
            catsBuffer.removeFirst()
        }
        if !images.isEmpty {
            images.removeFirst()
        }
        updateBuffer()
    }

    private func updateBuffer() {
        guard images.count < 2 else {
            return
        }
        for i in (images.count ..< 2) {
            if catsBuffer.count > i {
                images.append(catsBuffer[i].image)
            }
        }
    }

    
}
