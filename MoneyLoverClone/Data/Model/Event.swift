//
//  File.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {
    @objc dynamic var identify = ""
    @objc dynamic var name = ""
    @objc dynamic var image = ""
    @objc dynamic var endDate = Date()
    @objc dynamic var inProgress = true
    
    convenience init(name: String, image: String, endDate: Date) {
        self.init()
        self.identify = UUID().uuidString
        self.image = image
        self.name = name
        self.endDate = endDate
    }

    override class func primaryKey() -> String? {
        return "identify"
    }
}
