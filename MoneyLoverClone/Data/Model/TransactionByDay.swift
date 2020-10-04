//
//  TransactionByDay.swift
//  MoneyLoverClone
//
//  Created by KIMOCHI on 10/4/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

struct TransactionByDay {
    var date = Date()
    var summaryMoney = 0
    var transactionArray = [Transaction]()
    
    init(date: Date, transactionArray: [Transaction]) {
        self.date = date
        self.transactionArray = transactionArray.sorted(by: {
            $0.date.timeIntervalSinceReferenceDate > $1.date.timeIntervalSinceReferenceDate
        })
        transactionArray.forEach {
            if $0.type == "income" {
                summaryMoney += $0.money
            } else {
                summaryMoney -= $0.money
            }
        }
    }
}
