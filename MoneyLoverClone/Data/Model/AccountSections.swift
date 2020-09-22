//
//  AccountSections.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

enum AccountSections: Int, CaseIterable , CustomStringConvertible {
    case chung
    case logout
    var description: String {
        switch self {
        case .chung:
            return "Nhóm"
        case .logout:
        return "Cài đặt"
        }
    }
}
