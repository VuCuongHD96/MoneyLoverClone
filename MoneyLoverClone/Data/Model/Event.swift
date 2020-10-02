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
    @objc dynamic var idEvent = 0
    @objc dynamic var estimateDay = 0
    @objc dynamic var nameEvent = ""
    @objc dynamic var imgEvent = ""
    @objc dynamic var cash: Float = 0
    @objc dynamic var endDate = Date()
    @objc dynamic var inProgress = true
    var category = [Category]()
    
    convenience init(idEvent: Int, estimateDay: Int, nameEvent: String, imgEvent: String, cash: Float, inProgress: Bool, endDate: Date) {
        self.init()
        self.idEvent = idEvent
        self.estimateDay = estimateDay
        self.imgEvent =  imgEvent
        self.nameEvent = nameEvent
        self.cash = cash
        self.category = category
        self.inProgress = inProgress
        self.endDate = endDate
    }
    
    static func incrementaID() -> Int {
            let realm = try? Realm()
            if let retNext = realm?.objects(Event.self).sorted(byKeyPath: "idEvent").first?.idEvent {
                return retNext + 1
            } else {
                return 1
            }
        }
    
    override class func primaryKey() -> String? {
        return "idEvent"
    }
}
