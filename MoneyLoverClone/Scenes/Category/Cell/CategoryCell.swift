//
//  CategoryCell.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class CategoryCell: UITableViewCell, NibReusable {
    
    // MARK: - Outlet
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - Views
    private func setupViews() {
        selectionStyle = .none
    }

    // MARK: - Data
    func setContent(data: Category) {
        categoryImageView.image = UIImage(named: data.image)
        nameLabel.text = data.name
    }
}
