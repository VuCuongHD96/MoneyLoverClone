//
//  Int+.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

extension Int {
    func convertToMoneyFormat() -> String {
        let moneyString = String(self)
        var newMoney = moneyString.replacingOccurrences(of: ",", with: "")
        newMoney = moneyString.replacingOccurrences(of: ".", with: "")
        let amount = Double(newMoney) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: amount)
        guard let self = numberFormatter.string(from: nsNumber) else { return "" }
        return self  + ".00"
    }
    
    func convertToEditFormat() -> String {
        let moneyString = String(self)
        let newMoney = moneyString.replacingOccurrences(of: ",", with: "")
        let amount = Double(newMoney) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: amount)
        guard let self = numberFormatter.string(from: nsNumber) else { return "" }
        return self
    }
}
