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
}

class NewsfeedCell: UITableViewCell {
    @IBOutlet weak var groupIconImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsImageView: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var sharesImageView: UIImageView!
    @IBOutlet weak var sharesCountLabel: UILabel!
    @IBOutlet weak var viewsImageView: UIImageView!
    @IBOutlet weak var viewsCountLabel: UILabel!

    func set(viewModel: FeedCellViewModel) {
        groupNameLabel.text = viewModel.groupName
        dateLabel.text = viewModel.date
        newsTextLabel.text = viewModel.text
        likesCountLabel.text = viewModel.likes
        commentsCountLabel.text = viewModel.comments
        sharesCountLabel.text = viewModel.shares
        viewsCountLabel.text = viewModel.views
    }
}
