//
//  DetailTableViewCell.swift
//  MoneyLoverClone
//
//  Created by Tao Trong Nghia on 10/6/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

class DetailTableViewCell: UITableViewCell, NibReusable {
    
    // MARK: - Outlet
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var moneyOfCategoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    let transactionType = UserDefaults.standard.string(forKey: "transactionType")
    override func awakeFromNib() {
        super.awakeFromNib()
        setMoneyColor()
    }
    
    func setMoneyColor() {
        if transactionType == TransactionType.income.rawValue {
            moneyOfCategoryLabel.textColor = .blue
        } else {
            moneyOfCategoryLabel.textColor = .red
        }
    }
}
