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
    func request(path: String, params: [String: String], completition: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {

    private let authService: AuthService

    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }

    // MARK: - Request to API from URL

    func request(path: String, params: [String : String], completition: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else {
            return
        }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version

        let url = self.url(from: API.newsFeed, params: allParams)
//        print(url)

        let request = AF.request(url)
        request.validate().responseJSON { (response) -> Void in
            completition(response.data, response.error)
        }
    }

    // MARK: - Creating URL

    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.newsFeed
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
