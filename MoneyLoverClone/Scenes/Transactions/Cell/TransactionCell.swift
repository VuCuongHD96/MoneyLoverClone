//
//  TransactionCell.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/21/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class TransactionCell: UITableViewCell, NibReusable {

    // MARK: - Outlet
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var categoryName: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - View
    private func setupView() {
        selectionStyle = .none
    }
}
