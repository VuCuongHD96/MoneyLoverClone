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
    
    // MARK: - Properties
    struct Constant {
        static let dateFormat = "EEEE,dd,MMMM yyyy"
    }
    var formatter = DateFormatter()
    let today = Date()
    
    // MARK: - Data
    func setContent(data: TransactionByDay) {
        moneyLabel.text = data.summaryMoney.convertToMoneyFormat()
        setupTime(from: data.date)
    }
    
    private func setupTime(from date: Date) {
        formatter.locale = Locale(identifier: "vi")
        formatter.dateFormat = Constant.dateFormat
        let dateString = formatter.string(from: date)
        let stringArray = dateString.split(separator: ",")
        dayLabel.text = String(stringArray[1])
        dayOfWeakLabel.text = String(stringArray[0])
        monthYearLabel.text = String(stringArray[2])
        let todayString = formatter.string(from: today)
        if dateString == todayString {
            dayOfWeakLabel.text = "Hôm nay"
        }
        let yesterday = formatter.string(from: Date() - 1.days)
        if dateString == yesterday {
            dayOfWeakLabel.text = "Hôm qua"
        }
    }
    
    static func instantiate() -> HeaderTransactionView {
        guard let view = Bundle.main.loadNibNamed("HeaderTransactionView", owner: self, options: nil)?.first as? HeaderTransactionView else {
            return HeaderTransactionView()
        }
        return view
    }
}
