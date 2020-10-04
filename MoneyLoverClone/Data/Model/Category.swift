//
//  Category.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

struct Category: Equatable {
    var image: String
    var name: String
    
    init() {
        self.image = ""
        self.name = ""
    }
    
    init(image: String, name: String) {
        self.image = image
        self.name = name
    }
}
