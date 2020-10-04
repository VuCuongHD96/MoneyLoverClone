//
//  HeaderTransactionView.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/18/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

final class HeaderTransactionView: UIView {

    // MARK: - Outlet
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dayOfWeakLabel: UILabel!
    @IBOutlet private weak var monthYearLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    
    // MARK: - Views
    func setContent(data: TransactionByDay) {
        moneyLabel.text = String(data.summaryMoney).convertToMoneyFormat()
        let dateString = data.dateString
        
    }
}
