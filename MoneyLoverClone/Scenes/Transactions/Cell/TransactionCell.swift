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
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    
    // MARK: - Properties
    var database: DBManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupData()
        setupView()
    }
    
    // MARK: - Data
    private func setupData() {
        database = DBManager.shared
    }
    
    // MARK: - View
    private func setupView() {
        selectionStyle = .none
    }
    
    private func setupCostColor(_ transactionType: TransactionType) {
        switch transactionType {
        case .expendsed:
            costLabel.textColor = .systemRed
        case .income:
            costLabel.textColor = .systemBlue
        }
    }
    
    // MARK: - Data
    func setcontent(data: Transaction) {
        guard let category = database?.fetchCategory(from: data.categoryID) else { return }
        categoryImageView.image = UIImage(named: category.image)
        categoryNameLabel.text = category.name
        noteLabel.text = data.note
        costLabel.text = data.money.convertToMoneyFormat()
        guard let transactionType = TransactionType(rawValue: data.type) else {
            return
        }
        setupCostColor(transactionType)
    }
}
