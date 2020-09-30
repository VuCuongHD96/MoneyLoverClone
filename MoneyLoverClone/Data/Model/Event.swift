//
//  File.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

class Event {
    var idEvent = 0
    var estimateDay = 0
    var nameEvent = ""
    var imgEvent = ""
    var cash: Float = 0
    var category: Category
    
    init(idEvent: Int, endDate: Int, nameEvent: String, imgEvent: String, cash: Float, category: Category) {
        self.idEvent = idEvent
        self.estimateDay = endDate
        self.imgEvent =  imgEvent
        self.nameEvent = nameEvent
        self.cash = cash
        self.category = category
    }
}
