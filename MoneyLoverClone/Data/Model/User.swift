//
//  User.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var identify = ""
    @objc dynamic var email = ""
    @objc dynamic var name = ""
    @objc dynamic var avatar = ""
    
    convenience init(name: String, email: String, avatar: String) {
        self.init()
        self.identify = UUID().uuidString
        self.email = email
        self.name = name
        self.avatar = avatar
    }

    override class func primaryKey() -> String? {
        return "identify"
    }
}
