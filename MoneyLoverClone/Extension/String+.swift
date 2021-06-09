//
//  String+.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

extension String {
    func convertToMoneyFormat() -> String {
        let newMoney = self.replacingOccurrences(of: ",", with: "")
        let amount = Double(newMoney) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: amount)
        guard let self = numberFormatter.string(from: nsNumber) else { return "" }
        return self
    }
    
    func convertToInt() -> Int {
        let moneyString = self.replacingOccurrences(of: ",", with: "")
        return Int(moneyString) ?? 0
    }
    
    func convertToEditFormat() -> String {
        let newMoney = self.replacingOccurrences(of: ",", with: "")
        let amount = Double(newMoney) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: amount)
        guard let self = numberFormatter.string(from: nsNumber) else { return "" }
        return self
    }

    func getDayOfWeek() -> Substring {
        let stringArray = self.split(separator: "-")
        return stringArray[1]
    }
}
