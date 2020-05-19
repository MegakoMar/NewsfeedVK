//
//  WebImageView.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 19.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import UIKit
import Kingfisher

class WebImageView: UIImageView {
    func setImage(imageURL: String) {
        guard let url = URL(string: imageURL) else {
            return
        }
        self.kf.setImage(with: url)
    }
}
