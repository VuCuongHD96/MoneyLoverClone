//
//  File.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

class Event {
    var id: Int = 0
    var estimateDay : Int = 0
    var nameEvent : String = ""
    var imgEvent : String = ""
    var cash : Float = 0
    var category : Category
    
    init(id: Int, endDate : Int, nameEvent : String, imgEvent : String, cash: Float, category : Category) {
        self.id = id
        self.estimateDay = endDate
        self.imgEvent =  imgEvent
        self.nameEvent = nameEvent
        self.cash = cash
        self.category = category
    }
}
