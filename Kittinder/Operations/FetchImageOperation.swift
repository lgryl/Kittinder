// Created 21/12/2020

import UIKit

class FetchImageOperation: AsynchronousOperation {
    private let networkProvider: NetworkProvider
    private let imageURL: URL

    var image: UIImage?

    init(imageURL: URL, networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
        self.imageURL = imageURL
    }

    override func main() {
        networkProvider.fetch(url: imageURL) { result in
            defer {
                self.state = .finished
            }
            switch result {
            case .success(let data):
                self.image = UIImage(data: data)
            case .failure(let error):
                print(error)
            }
        }

    }
}
