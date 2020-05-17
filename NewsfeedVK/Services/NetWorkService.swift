//
//  NetworkService.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 17.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation

class NetWorkService {

    private let authService: AuthService

    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }

    func getFeed() {
        var components = URLComponents()

        guard let token = authService.token else {
            return
        }

        let params = ["filters": "post"]
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version

        components.scheme = API.scheme
        components.host = API.host
        components.path = API.newsFeed
        components.queryItems = allParams.map { URLQueryItem(name: $0, value: $1) }

        let url = components.url!
        print(url)

        //https://api.vk.com/method/users.get?user_ids=210700286&fields=bdate&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3&v=5.103
    }
}
