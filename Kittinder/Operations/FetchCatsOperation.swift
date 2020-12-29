// Created 21/12/2020

import Foundation

class FetchCatsOperation: AsynchronousOperation {
    private static let defaultNumberOfCatsToFetch = 10

    private let networkProvider: NetworkProvider

    private let apiKey: String
    private let numberOfCatsToFetch: Int

    var cats: [Cat] = []

    init(apiKey: String,
         numberOfCatsToFetch: Int = FetchCatsOperation.defaultNumberOfCatsToFetch,
         networkProvider: NetworkProvider) {
        self.apiKey = apiKey
        self.numberOfCatsToFetch = numberOfCatsToFetch
        self.networkProvider = networkProvider
    }

    override func main() {
        let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=\(numberOfCatsToFetch)&mime_types=jpg%2Cpng&size=med")!
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        networkProvider.fetch(request: request) { result in
            defer {
                self.state = .finished
            }
            switch result {
            case .success(let data):
                do {
                    self.cats = try JSONDecoder().decode([Cat].self, from: data)
                } catch {

                }
            case .failure(let error):
                print(error)
            }
        }

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            switch (data, response, error) {
            case (.some(let data), .some(let response), _) where response is HTTPURLResponse:
                do {
                    self.cats = try JSONDecoder().decode([Cat].self, from: data)
                    self.state = .finished
                } catch {
                    self.state = .finished
                }
            default:
                break
            }
        }
        dataTask.resume()
    }
}
