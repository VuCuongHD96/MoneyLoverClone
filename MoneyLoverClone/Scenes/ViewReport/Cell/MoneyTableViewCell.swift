//
//  MoneyTableViewCell.swift
//  MoneyLoverClone
//
//  Created by Tao Trong Nghia on 10/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

class MoneyTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var beginBalanceLabel: UILabel!
    @IBOutlet private weak var endBalanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
