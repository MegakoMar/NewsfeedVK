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

protocol NewsfeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachments: [FeedCellAphotoAttachmentViewModel]) -> FeedCellSizes
}

class NewsfeedCellLayoutCalculator: NewsfeedCellLayoutCalculatorProtocol {
    private let screenWidth: CGFloat

    init(screenWidth: CGFloat = UIScreen.main.bounds.width) {
        self.screenWidth = screenWidth
    }

    func sizes(postText: String?, photoAttachments: [FeedCellAphotoAttachmentViewModel]) -> FeedCellSizes {
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

        if let attachment = photoAttachments.first {
            let ratio = CGFloat(Double(attachment.height) / Double(attachment.width))
            if photoAttachments.count == 1 {
                attachmentFrame.size = CGSize(width: screenWidth, height: screenWidth * ratio + Constants.collectionViewCellsMargins * 2)
            } else if photoAttachments.count > 1 {
                var height = CGFloat()
                var heightArray: [CGFloat] = []

                if photoAttachments.count % 2 == 0 {
                    height += setHeight(count: 0, heightArray: heightArray, photoAttachments: photoAttachments)
                } else {
                    height = screenWidth * ratio
                    heightArray.append(height)
                    height += setHeight(count: 1, heightArray: heightArray, photoAttachments: photoAttachments)
                }

                attachmentFrame.size = CGSize(width: screenWidth, height: height)
            }
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

    // MARK: - Calculating height of collectionViewx

    private func setHeight(count: Int, heightArray: [CGFloat], photoAttachments: [FeedCellAphotoAttachmentViewModel]) -> CGFloat {
        let width = screenWidth / 2
        var height = CGFloat()
        var heightArray = heightArray
        var count = count

        for item in count..<photoAttachments.count {
            let ratioOfItem = CGFloat(Double(photoAttachments[item].height) / Double(photoAttachments[item].width))
            heightArray.append(width * ratioOfItem)
        }

        while count < photoAttachments.count {
            height += max(heightArray[count], heightArray[count+1])
            count += 2
        }
        return height
    }
}
