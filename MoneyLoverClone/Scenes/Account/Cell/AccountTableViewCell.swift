//
//  AccountTableViewCell.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class AccountTableViewCell: UITableViewCell, NibReusable {

    // MARK: - Outlet
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Data
    func setContent(data: AccountCellModel) {
        iconImageView.image = UIImage(named: data.image)
        nameLabel.text = data.name
    }
}
