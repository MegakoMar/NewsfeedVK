//
//  NetworkService.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 17.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation
import Alamofire

protocol Networking {
    func request(path: String, params: [String: String], completition: @escaping (URL?) -> Void)
}

class NetWorkService: Networking {

    private let authService: AuthService

    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }

    func request(path: String, params: [String : String], completition: @escaping (URL?) -> Void) {
        guard let token = authService.token else {
            return
        }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version

        let url = self.url(from: API.newsFeed, params: allParams)

        completition(url)
//        let session = URLSession.init(configuration: .default)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) { (data, response, error) in
//            DispatchQueue.main.async {
//                complition(data, error)
//            }
//        }
//        task.resume()
    }

    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.newsFeed
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}


//https://api.vk.com/method/users.get?user_ids=210700286&fields=bdate&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3&v=5.103
