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
    @objc dynamic var identify = ""
    @objc dynamic var money = 0
    @objc dynamic var categoryID = ""
    @objc dynamic var note: String?
    @objc dynamic var date = Date()
    @objc dynamic var idEvent: String?
    @objc dynamic var type = ""
    
    convenience init(money: Int, categoryID: String, note: String? = nil, date: Date, idEvent: String? = nil, transactionType: String) {
        self.init()
        self.identify = UUID().uuidString
        self.money = money
        self.categoryID = categoryID
        self.note = note
        self.date = date
        self.idEvent = idEvent
        self.type = transactionType
    }
    
    required init() {
        self.identify = UUID().uuidString
    }
    
    func clone(from transaction: Transaction) {
        self.identify = transaction.identify
        self.money = transaction.money
        self.categoryID = transaction.categoryID
        self.note = transaction.note
        self.date = transaction.date
        self.idEvent = transaction.idEvent
        self.type = transaction.type
    }

    override class func primaryKey() -> String? {
        return "identify"
    }
}
