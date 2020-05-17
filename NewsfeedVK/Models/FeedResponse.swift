//
//  FeedResponse.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 16.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation

struct FeedResponseWrapped: Codable {
    let response: FeedResponse
}

struct FeedResponse: Codable {
    var items: [FeedItem]
//    var profiles: [Profile]
//    var groups: [Group]
//    var nextFrom: String?
}

struct FeedItem: Codable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
//    let attachments: [Attechment]?

    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case postId = "post_id"
        case text
        case date
        case comments
        case likes
        case reposts
        case views
    }
}

struct CountableItem: Codable {
    let count: Int
}

//struct Attechment: Codable {
//    let photo: Photo?
//}
//
//struct Photo: Codable {
//    let sizes: [PhotoSize]
//
//    var height: Int {
//         return getPropperSize().height
//    }
//
//    var width: Int {
//        return getPropperSize().width
//    }
//
//    var srcBIG: String {
//         return getPropperSize().url
//    }
//
//    private func getPropperSize() -> PhotoSize {
//        if let sizeX = sizes.first(where: { $0.type == "x" }) {
//            return sizeX
//        } else if let fallBackSize = sizes.last {
//             return fallBackSize
//        } else {
//            return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
//        }
//    }
//}
//
//struct PhotoSize: Codable {
//    let type: String
//    let url: String
//    let width: Int
//    let height: Int
//}
//
//
//protocol ProfileRepresenatable {
//    var id: Int { get }
//    var name: String { get }
//    var photo: String { get }
//}
//
//struct Profile: Codable, ProfileRepresenatable {
//    let id: Int
//    let firstName: String
//    let lastName: String
//    let photo100: String
//
//    var name: String { return firstName + " " + lastName }
//    var photo: String { return photo100 }
//}
//
//struct Group: Codable, ProfileRepresenatable {
//    let id: Int
//    let name: String
//    let photo100: String
//
//    var photo: String { return photo100 }
//}