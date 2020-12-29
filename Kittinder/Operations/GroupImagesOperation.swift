// Created 21/12/2020

import UIKit

class GroupImagesOperation: Operation {
    var images: [UIImage] = []

    override func main() {
        images.append(contentsOf:dependencies.compactMap {
            ($0 as? FetchImageOperation)?.image
        })
    }
}
