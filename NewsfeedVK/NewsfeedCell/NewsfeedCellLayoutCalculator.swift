//
//  NewsfeedCellLayoutCalculator.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 19.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import UIKit

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomOfCellFrame: CGRect
    var totalHeigth: CGFloat
}

struct Constants {
//    static let postTextHeightDefaultHeight: CGFloat = 17
//    static let postImageViewDefaultHeight: CGFloat = 275
    static let topStackHeight: CGFloat = 40
    static let bottomViewHeight: CGFloat = 26
    static let bottomInserts = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
    static let topStackInserts = UIEdgeInsets(top: 15, left: 18, bottom: 16, right: 18)
    static let postLabelFont = UIFont.systemFont(ofSize: 14)
}

protocol NewsfeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: FeedCellAphotoAttachmentViewModel?) -> FeedCellSizes
}

class NewsfeedCellLayoutCalculator: NewsfeedCellLayoutCalculatorProtocol {
    private let screenWidth: CGFloat

    init(screenWidth: CGFloat = UIScreen.main.bounds.width) {
        self.screenWidth = screenWidth
    }

    func sizes(postText: String?, photoAttachment: FeedCellAphotoAttachmentViewModel?) -> FeedCellSizes {
        let postLabelFrameY = Constants.topStackInserts.top + Constants.topStackHeight + Constants.topStackInserts.bottom

        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.topStackInserts.left, y: postLabelFrameY), size: CGSize.zero)

        if let text = postText, !text.isEmpty {
            let width = screenWidth - Constants.topStackInserts.left - Constants.topStackInserts.right
            let heigth = text.height(width: width, font: Constants.postLabelFont)
            postLabelFrame.size = CGSize(width: width, height: heigth)
        }

        let postImageFrameAfterLabel = postLabelFrameY + postLabelFrame.height + Constants.topStackInserts.bottom
        let attachmentFrameY = postLabelFrame.size == CGSize.zero ? postLabelFrameY : postImageFrameAfterLabel
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentFrameY), size: CGSize.zero)

        if let attachment = photoAttachment {
            let ratio = CGFloat(Double(attachment.height) / Double(attachment.width))
            attachmentFrame.size = CGSize(width: screenWidth, height: screenWidth * ratio)
        }

        let bottomViewFrameY = max(postLabelFrame.maxY, attachmentFrame.maxY) + Constants.bottomInserts.top
        let bottomViewWidth = screenWidth - Constants.bottomInserts.left - Constants.bottomInserts.right
        let bottomViewFrame = CGRect(origin: CGPoint(x: Constants.bottomInserts.left, y: bottomViewFrameY), size: CGSize(width: bottomViewWidth, height: Constants.bottomViewHeight))

        let totalHeight: CGFloat = bottomViewFrame.maxY + Constants.bottomInserts.bottom

        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: attachmentFrame,
                     bottomOfCellFrame: bottomViewFrame,
                     totalHeigth: totalHeight)
    }
}
