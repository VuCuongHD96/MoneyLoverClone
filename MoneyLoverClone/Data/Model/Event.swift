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
    @objc dynamic var endDate: Date
    @objc dynamic var inProgress = true
    
    override class func primaryKey() -> String? {
        return "idEvent"
    }
    
    var category = [Category]()
    
    init(idEvent: Int, estimateDay: Int, nameEvent: String, imgEvent: String, cash: Float, inProgress: Bool, endDate: Date, category: [Category]) {
        self.idEvent = idEvent
        self.estimateDay = estimateDay
        self.imgEvent =  imgEvent
        self.nameEvent = nameEvent
        self.cash = cash
        self.category = category
        self.inProgress = inProgress
        self.endDate = endDate
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func incrementaID() -> Int {
        let realm = try? Realm()
        if let retNext = realm?.objects(Event.self).sorted(byKeyPath: "id").first?.idEvent {
            return retNext + 1
        } else {
            return 1
        }
    }
}
//    override required init() {
//        fatalError("init() has not been implemented")
//    }

//import Foundation
//import RealmSwift
//
//class Nguoi: Object {
//    @objc dynamic var key = ""
//    @objc dynamic var name = ""
//    @objc dynamic var age = 0
//
//    convenience init(key: String, name: String, age: Int) {
//        self.init()
//        self.key = key
//        self.name = name
//        self.age = age
//    }
//
//    convenience init(nguoi: Nguoi) {
//        self.init()
//        self.key = nguoi.key
//        self.name = nguoi.name
//        self.age = nguoi.age
//    }
//
//    override static func primaryKey() -> String? {
//        return "key"
//    }
//
//    func clone(from nguoi: Nguoi) {
//        self.key = nguoi.key
//        self.name = nguoi.name
//        self.age = nguoi.age
//    }
//}
