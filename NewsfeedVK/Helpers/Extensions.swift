//
//  Extensions.swift
//  NewsfeedVK
//
//  Created by Роман Комаров on 20.05.2020.
//  Copyright © 2020 Роман Комаров. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extension func height for String

extension String {
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: font],
                                     context: nil)
        return ceil(size.height)
    }
}
