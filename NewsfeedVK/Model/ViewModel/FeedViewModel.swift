//
//  FeedViewModel.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 18.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var iconGroupImage: String
        var groupName: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachments: [FeedCellAphotoAttachmentViewModel]
        var sizes: FeedCellSizes
    }

    struct FeedCellPhotoAttachment: FeedCellAphotoAttachmentViewModel {
        var photoUrl: String
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}
