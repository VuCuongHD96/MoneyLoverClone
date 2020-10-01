//
//  AddEventCell.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/1/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class AddEventCell: UITableViewCell, NibReusable {

    // MARK: - Outlet
    @IBOutlet private weak var addEventLabel: UILabel!

    // MARK: - Outlet
    override func awakeFromNib() {
        super.awakeFromNib()
        let attributedString = NSAttributedString(string: "Thêm sự kiện",
                                                  attributes: [.underlineStyle: 1,
                                                               .foregroundColor: UIColor.systemGreen])
        addEventLabel.attributedText = attributedString
    }
}
