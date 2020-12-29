// Created 21/12/2020

import Foundation

class FetchCatsOperation: AsynchronousOperation {
    private let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    var cats: [Cat] = []

    override func main() {
        let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=10&mime_types=jpg%2Cpng&size=med")!
        var request = URLRequest(url: url)
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        networkProvider.fetch(request: request) { result in
            switch result {
            case .success(let data):
                defer {
                    self.state = .finished
                }
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
