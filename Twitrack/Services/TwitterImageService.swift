//
//  TwitterImageService.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 05/08/2021.
//

import Foundation

class TwitterImageService {

    var decoder: JSONDecoder
    var session: URLSession

    init(decoder: JSONDecoder = .init(), session: URLSession = .shared) {
        self.decoder = decoder
        self.session = session
    }

    func fetchAvatar(_ query: String, completion: @escaping (Result<Data, Error>) -> Void) {

        guard let url = URL(string: query) else {
            completion(.failure(NSError(domain: "Unable to build the url from \(query)", code: -998, userInfo: nil)))
            return
        }

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let data = data ?? Data()
            completion(.success(data))
        }.resume()
    }
}
