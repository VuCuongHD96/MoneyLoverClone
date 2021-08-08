//
//  Date+.swift
//  MoneyLoverClone
//
//  Created by Cuong on 6/9/21.
//  Copyright © 2021 Vu Xuan Cuong. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    
    var today: Date {
        return Date()
    }
    
    func convertToEDMYString() -> String {
        let format = DateFormatter()
        format.dateFormat = "EEEE-dd-MM-yyyy"
        format.locale = Locale(identifier: "vi")
        let dateString = format.string(from: self)
        return dateString
    }
    
    func isThisMonth(with date: Date) -> Bool {
        return self.month == date.month && self.year == date.year
    }
    
    func isPreviousMonth() -> Bool {
        return self.month + 1 == today.month
    }
    
    func isPast() -> Bool {
        today.month - self.month >= 2
    }
}
