//
//  NetworkDataFetcher.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 17.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {

    let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    // MARK: - Getting Newsfeed

    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters": "post"]
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error)")
                response(nil)
            }
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }

    // MARK: - Decoding JSON Data

    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from,
        let response = try? decoder.decode(type.self, from: data) else {
            return nil
        }
        return response
    }
}
