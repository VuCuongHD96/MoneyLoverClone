//
//  TransactionSectionModel.swift
//  MoneyLoverClone
//
//  Created by Cuong on 6/9/21.
//  Copyright © 2021 Vu Xuan Cuong. All rights reserved.
//

import Foundation

struct TransactionSectionModel {
    var headerData: TransactionHeaderModel
    var transactionArray: [Transaction]
}

extension TransactionSectionModel: Comparable {
    static func < (lhs: TransactionSectionModel, rhs: TransactionSectionModel) -> Bool {
        return lhs.headerData.dateString.getDayOfWeek() < rhs.headerData.dateString.getDayOfWeek()
    }
    
    static func == (lhs: TransactionSectionModel, rhs: TransactionSectionModel) -> Bool {
        return lhs.headerData.dateString == rhs.headerData.dateString
    }
    
    static func > (lhs: TransactionSectionModel, rhs: TransactionSectionModel) -> Bool {
        return lhs.headerData.dateString.getDayOfWeek() > rhs.headerData.dateString.getDayOfWeek()
    }
}
