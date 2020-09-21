//
//  Year.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/18/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import RealmSwift

class Year: Object {
    @objc dynamic var userID = ""
    @objc dynamic var year = 0
    
    convenience init(userID: String) {
        self.init()
        self.userID = userID
    }
    
    func getYear() -> Int {
        return 0
    }
}
