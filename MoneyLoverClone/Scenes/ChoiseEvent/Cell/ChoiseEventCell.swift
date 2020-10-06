//
//  ChoiseEventCell.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/7/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class ChoiseEventCell: UITableViewCell, NibReusable {

    // MARK: - Outlet
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var eventNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Data
    func setContent(data: Event) {
        eventImageView.image = UIImage(named: data.image)
        eventNameLabel.text = data.name
    }
}
