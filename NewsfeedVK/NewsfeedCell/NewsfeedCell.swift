//
//  NewsfeedCell.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 18.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import UIKit
import Stevia

class NewsfeedCell: UITableViewCell {
    @IBOutlet weak var groupIconImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsImageView: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var eyesImageView: UIImageView!
    @IBOutlet weak var eyesCountLabel: UILabel!
}
