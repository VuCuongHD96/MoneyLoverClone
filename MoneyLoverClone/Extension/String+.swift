//
//  String+.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/2/20.
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
}
