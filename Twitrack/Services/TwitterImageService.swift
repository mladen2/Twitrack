//
//  TwitterImageService.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 05/08/2021.
//

import Foundation

class TwitterImageService {

//    let baseURL = "https://pbs.twimg.com/profile_images" // if needed it comes in anyway

    var decoder: JSONDecoder
    var session: URLSession

    init(decoder: JSONDecoder = .init(), session: URLSession = .shared) {
        self.decoder = decoder
        self.session = session
    }

    func fetchAvatar(_ query: String, completion: @escaping (Result<Data, Error>) -> Void) {
        pr()
        guard let url = URL(string: query) else {
            completion(.failure(NSError(domain: "Unable to build the url from \(query)", code: -999, userInfo: nil)))
            return
        }
        pr("url: \(url)")
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
