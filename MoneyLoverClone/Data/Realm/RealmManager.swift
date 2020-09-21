//
//  RealmManager.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/18/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import RealmSwift

class RealmManager {
    private var database: Realm!
    static let shared = RealmManager()
    
    private init() {
        database = try? Realm()
    }
}
