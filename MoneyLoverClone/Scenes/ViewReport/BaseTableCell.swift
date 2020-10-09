//
//  BaseTBCell.swift
//  MoneyLoverClone
//
//  Created by Tao Trong Nghia on 10/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class BaseTableCell: UITableViewCell {
    static func identifier() -> String {
        return String(describing:self)
    }
    static func height() -> CGFloat {
        return 0
    }
    static func registerCellByClass(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier:identifier())
    }
    static func registerCellByNib(_ tableView: UITableView) {
        let nib = UINib(nibName:identifier(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier:identifier())
    }
    static func loadCell(_ tableView: UITableView) -> BaseTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:identifier()) as! BaseTableCell
        return cell
    }
}
