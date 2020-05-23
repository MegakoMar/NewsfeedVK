//
//  CollectionViewFirstCell.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 21.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewFirstCell: UICollectionViewCell {

    static let reuseID = "CollectionViewFirstCell"

    @IBOutlet weak var imageView: WebImageView!

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = #colorLiteral(red: 0.2992576957, green: 0.467685163, blue: 1, alpha: 1)
//        configImageView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func prepareForReuse() {
        imageView.image = nil
    }
//
//    // MARK: Configuration imageView
//
//    private func configImageView() {
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//
//        addSubview(imageView)
//        imageView.fillSuperview()
//    }

    func set(imageURL: String?) {
        imageView.setImage(imageURL: imageURL)
//        print(#function)
    }
}
