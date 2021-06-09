//
//  HeaderTransactionView.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/18/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import SwiftDate

final class HeaderTransactionView: UIView {

    // MARK: - Outlet
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dayOfWeakLabel: UILabel!
    @IBOutlet private weak var monthYearLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    
    // MARK: - Define
    struct Constant {
        static let dateFormat = "EEEE,dd,MMMM yyyy"
    }
    
    // MARK: - Properties
    var formatter = DateFormatter()
    let today = Date()
    
    // MARK: - Data
    func setContent(data: TransactionHeaderModel) {
        setupTime(data: data.dateString)
        moneyLabel.text = String(data.money).convertToMoneyFormat()
    }
    
    private func setupTime(data: String) {
        let stringArray = data.split(separator: "-")
        
        let dayData = String(stringArray[1])
        let dayOfWeakData = String(stringArray[0])
        let monthData = String(stringArray[2])
        let yearData = String(stringArray[3])
        
        dayLabel.text = dayData
        dayOfWeakLabel.text = dayOfWeakData
        monthYearLabel.text = "tháng " + monthData + " " + yearData
    }
    
    static func instantiate() -> HeaderTransactionView {
        guard let view = Bundle.main.loadNibNamed("HeaderTransactionView", owner: self, options: nil)?.first as? HeaderTransactionView else {
            return HeaderTransactionView()
        }
        return view
    }
}
