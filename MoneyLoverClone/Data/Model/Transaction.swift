//
//  Transaction.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/2/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation
import RealmSwift

class Transaction: Object {
    @objc dynamic var idTransaction = ""
    @objc dynamic var money = 0
    @objc dynamic var category = ""
    @objc dynamic var note: String?
    @objc dynamic var date = Date()
    @objc dynamic var idEvent: String?
    @objc dynamic var type = ""
    
    convenience init(money: Int, category: String, note: String? = nil, date: Date, idEvent: String? = nil, transactionType: TransactionType) {
        self.init()
        self.idTransaction = UUID().uuidString
        self.money = money
        self.category = category
        self.note = note
        self.date = date
        self.idEvent = idEvent
        self.type = transactionType.rawValue
    }
    
    override class func primaryKey() -> String? {
        return "idTransaction"
    }
}
