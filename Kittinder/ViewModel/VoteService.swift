// Created 29/12/2020

import UIKit

class VoteService {
    private let networkProvider = NetworkProvider()

    func vote(imageID: String, like: Bool) {
        var request = URLRequest(url: URL(string: "https://api.thecatapi.com/v1/votes")!)
        request.httpMethod = HTTPMethod.post.toString()
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let vote = Vote(imageId: imageID,
                        userId: "testID",
                        liked: like)

        do {
            let jsonData = try JSONEncoder().encode(vote)
            request.httpBody = jsonData

            networkProvider.fetch(request: request) { result in
                if case let .success(data) = result {
                    print(data)
                }
            }
        } catch {
            print(error)
        }
    }

    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
    }
}
