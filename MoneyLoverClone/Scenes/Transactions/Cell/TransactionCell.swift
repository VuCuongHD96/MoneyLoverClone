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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
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
        categoryImageView.image = UIImage(named: data.category)
        noteLabel.text = data.note
        costLabel.text = String(data.money).convertToMoneyFormat()
        guard let transactionType = TransactionType(rawValue: data.type) else {
            return
        }
        setupCostColor(transactionType)
        switch transactionType {
        case .expendsed:
            fetchCategoryData(from: "ExpenseArray", category: data.category)
        case .income:
            fetchCategoryData(from: "RevenueArray", category: data.category)
        }
    }
    
    private func fetchCategoryData(from name: String, category: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let categoryDictionary = NSDictionary(contentsOfFile: path) else { return }
        guard let categoryName = categoryDictionary[category] as? String else {
            return
        }
        categoryNameLabel.text = categoryName
    }
}
