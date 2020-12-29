// Created 21/12/2020

import Foundation

struct NetworkProvider {
    private let session = URLSession.shared

    public func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        fetch(request: request, completion: completion)
    }

    public func fetch(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            switch (data, response, error) {
            case (.some(let data), .some(let response as HTTPURLResponse) , .none):
                if response.statusCode == 200 {
                    completion(.success(data))
                } else {
                    completion(.failure(.invalidResponseError))
                }
            case (_, _, .some(let error)):
                completion(.failure(.otherError(error)))
            default:
                completion(.failure(.invalidResponseError))
            }
        }
        dataTask.resume()
    }

    public enum Error: Swift.Error {
        case invalidResponseError
        case otherError(Swift.Error)
    }
}
