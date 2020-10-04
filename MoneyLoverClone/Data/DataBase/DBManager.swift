//
//  DBManager.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/2/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    static let shared = DBManager()
    private var database: Realm!
    
    private init() {
        database = try? Realm()
    }
    
    func saveTransaction(_ transaction: Transaction) {
        try? database?.write {
            database?.add(transaction)
        }
    }
    
    func fetchTransactions() -> [Transaction] {
        var arrayResult = database.objects(Transaction.self)
        arrayResult = arrayResult.sorted(byKeyPath: "date", ascending: false)
        return Array(arrayResult)
    }
}
