// Created 21/12/2020

import Foundation

struct NetworkProvider {
    private let session = URLSession.shared

    public func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            switch (data, response, error) {
            case (.some(let data), .some(let response as HTTPURLResponse) , .none):
                if response.statusCode == 200 {
                    completion(.success(data))
                }
            case (_, _, .some(let error)):
                completion(.failure(.otherError(error)))
            default:
                completion(.failure(.invalidResponseError))
            }
        }
    }

    public enum Error: Swift.Error {
        case invalidResponseError
        case otherError(Swift.Error)
    }
}
