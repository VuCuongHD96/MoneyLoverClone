//
//  CategoryIconCell.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/28/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class CategoryIconCell: UICollectionViewCell, NibReusable {

    // MARK: - Outlet
    @IBOutlet private weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Data
    func setContent(data: Category) {
        categoryImageView.image = UIImage(named: data.image)
    }
}
