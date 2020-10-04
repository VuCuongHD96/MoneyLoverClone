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
    
    // MARK: - Properties
    var categoryArray = [Category]()
    
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
        categoryName.text = data.category
        noteLabel.text = data.note
        costLabel.text = String(data.money).convertToMoneyFormat()
        setupCostColor(TransactionType(rawValue: data.type)!)
    }
    
    private func fetchCategoryData(from name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let nsDictionary = NSDictionary(contentsOfFile: path) else { return }
        categoryArray += nsDictionary.map {
            let imageString = $0.key as? String ?? ""
            let name = $0.value as? String ?? ""
            let category = Category(image: imageString, name: name)
            return category
        }
    }
    
    private func setupData() {
        fetchCategoryData(from: "ExpenseArray")
        fetchCategoryData(from: "RevenueArray")
    }
}
