// Created 29/12/2020

import Foundation

class CatsProvider {
    private let queue = OperationQueue()
    private let networkProvider = NetworkProvider()


    func provideCats(numberOfCats: Int, completion: @escaping ([CatData]) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            var result: [CatData] = []
            let fetchCatsOperation = FetchCatsOperation(apiKey: self.apiKey,
                                                        networkProvider: self.networkProvider)
            self.queue.addOperation(fetchCatsOperation)
            self.queue.waitUntilAllOperationsAreFinished()

            for cat in fetchCatsOperation.cats {
                guard let imageURL = URL(string: cat.url) else { continue }
                let fetchImageOperation = FetchImageOperation(imageURL: imageURL, networkProvider: self.networkProvider)
                fetchImageOperation.completionBlock = {
                    guard let catImage = fetchImageOperation.image else { return }
                    let catData = CatData(cat: cat, image: catImage)
                    result.append(catData)
                }
                self.queue.addOperation(fetchImageOperation)
            }
            self.queue.waitUntilAllOperationsAreFinished()

            DispatchQueue.main.async {
                completion(result)
            }
        }

//        fetchCatsOperation.completionBlock = { [weak self, unowned fetchCatsOperation] in
//            guard let self = self else { return }
//            let groupImagesOperation = GroupImagesOperation()
//            groupImagesOperation.completionBlock = { [unowned groupImagesOperation] in
//                let images = groupImagesOperation.images
//                DispatchQueue.main.async {
//                    self.catsBuffer.append(contentsOf: images)
//                    self.updateBuffer()
//                    self.isFetching = false
//                }
//            }
//            for cat in fetchCatsOperation.cats {
//                guard let imageURL = URL(string: cat.url) else { continue }
//                let fetchImageOperation = FetchImageOperation(imageURL: imageURL, networkProvider: self.networkProvider)
//                groupImagesOperation.addDependency(fetchImageOperation)
//                self.queue.addOperation(fetchImageOperation)
//            }
//            self.queue.addOperation(groupImagesOperation)
//        }
    }

    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
    }
}
