//
//  CollectionViewCell.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 21.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID = "CollectionViewCell"

    @IBOutlet weak var imageView: WebImageView!
    //    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    func set(imageURL: String?) {
        imageView.setImage(imageURL: imageURL)
        print(#function)
    }
}
