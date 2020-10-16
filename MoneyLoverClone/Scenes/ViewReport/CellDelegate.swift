//
//  CellDelegate.swift
//  MoneyLoverClone
//
//  Created by Tao Trong Nghia on 10/15/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

protocol CellDelegate: class {
    func showExpense(tag: Int)
    func showIncome(tag: Int)
}
