//
//  CollectionView.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 21.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation
import UIKit

class CollectionView: UICollectionView {

    var photos: [FeedCellAphotoAttachmentViewModel] = []
    let screenWidth = UIScreen.main.bounds.width

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        reloadData()
//        print(#function)
    }

//    init() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        super.init(frame: .zero, collectionViewLayout: layout)
//        delegate = self
//        dataSource = self
//        register(CollectionViewFirstCell.self, forCellWithReuseIdentifier: CollectionViewFirstCell.reuseID)
//        backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    // MARK: - Setting photos to CollectionView

    func set(photos: [FeedCellAphotoAttachmentViewModel]) {
        self.photos = photos
        reloadData()
    }
}


// MARK: - Extension UICollectionViewDelegate, UICollectionViewDataSource

extension CollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let firstCell = dequeueReusableCell(withReuseIdentifier: CollectionViewFirstCell.reuseID, for: indexPath) as! CollectionViewFirstCell
        firstCell.set(imageURL: photos[indexPath.row].photoUrl)
        return firstCell
    }
}

// MARK: - Extension UICollectionViewDelegateFlowLayout

extension CollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = CGFloat()
        var height = CGFloat()
        var sizes = CGSize()
        let ratio = CGFloat(Double(photos[indexPath.row].width) / Double(photos[indexPath.row].height))
        if indexPath.row == 0 {
            width = screenWidth
            height = width * ratio
            sizes = CGSize(width: width, height: height)
        } else {
            width = screenWidth / 2 - 4
            height = width * ratio
            sizes = CGSize(width: width, height: height)
        }
        return sizes
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
