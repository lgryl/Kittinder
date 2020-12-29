// Created 21/12/2020

import UIKit

class ViewModel: ObservableObject {
    private let queue = OperationQueue()
    private let networkProvider = NetworkProvider()

    @Published private(set) var isFetching = false
    @Published private(set) var images: [UIImage] = []
    private var imageBuffer: [UIImage] = []

    func removeTopCard() {
        removeTop()
        if imageBuffer.count < 5 {
            fetchIfNotFetching()
        }
    }

    func fetchIfNotFetching() {
        guard !isFetching else { return }
        fetch()
    }

    private func fetch() {
        isFetching = true
        let fetchCatsOperation = FetchCatsOperation(networkProvider: networkProvider)
        fetchCatsOperation.completionBlock = { [weak self, unowned fetchCatsOperation] in
            guard let self = self else { return }
            let groupImagesOperation = GroupImagesOperation()
            groupImagesOperation.completionBlock = { [unowned groupImagesOperation] in
                let images = groupImagesOperation.images
                DispatchQueue.main.async {
                    self.imageBuffer.append(contentsOf: images)
                    self.updateBuffer()
                    self.isFetching = false
                }
            }
            for url in fetchCatsOperation.cats.compactMap({ URL(string: $0.url) }) {
                let fetchImageOperation = FetchImageOperation(imageURL: url, networkProvider: self.networkProvider)
                groupImagesOperation.addDependency(fetchImageOperation)
                self.queue.addOperation(fetchImageOperation)
            }
            self.queue.addOperation(groupImagesOperation)
        }
        queue.addOperation(fetchCatsOperation)
    }

    private func removeTop() {
        if !imageBuffer.isEmpty {
            imageBuffer.removeFirst()
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
            if imageBuffer.count > i {
                images.append(imageBuffer[i])
            }
        }
    }
}
