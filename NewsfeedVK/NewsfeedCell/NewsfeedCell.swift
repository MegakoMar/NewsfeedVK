//
//  NewsfeedCell.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 18.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import UIKit

protocol FeedCellViewModel {
    var iconGroupImage: String { get }
    var groupName: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachment: FeedCellAphotoAttachmentViewModel? { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellAphotoAttachmentViewModel {
    var photoUrl: String { get }
    var width: Int { get }
    var height: Int { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomOfCellFrame: CGRect { get }
    var totalHeigth: CGFloat { get }
}

class NewsfeedCell: UITableViewCell {
    @IBOutlet weak var groupIconImageView: WebImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsImageView: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var sharesImageView: UIImageView!
    @IBOutlet weak var sharesCountLabel: UILabel!
    @IBOutlet weak var viewsImageView: UIImageView!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!

    func set(viewModel: FeedCellViewModel) {
        groupIconImageView.setImage(imageURL: viewModel.iconGroupImage)
        groupNameLabel.text = viewModel.groupName
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesCountLabel.text = viewModel.likes
        commentsCountLabel.text = viewModel.comments
        sharesCountLabel.text = viewModel.shares
        viewsCountLabel.text = viewModel.views
        postLabel.frame = viewModel.sizes.postLabelFrame
        postImageView.frame = viewModel.sizes.attachmentFrame

        if let photoAttachment = viewModel.photoAttachment {
            postImageView.setImage(imageURL: photoAttachment.photoUrl)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }

        bottomStackView.frame = viewModel.sizes.bottomOfCellFrame
    }
}
