//
//  Date+.swift
//  MoneyLoverClone
//
//  Created by Cuong on 6/9/21.
//  Copyright © 2021 Vu Xuan Cuong. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToEDMYString() -> String {
        let format = DateFormatter()
        format.dateFormat = "EEEE-dd-MM-yyyy"
        format.locale = Locale(identifier: "vi")
        let dateString = format.string(from: self)
        
        return dateString
    }
}
