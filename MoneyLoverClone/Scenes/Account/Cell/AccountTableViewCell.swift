//
//  AccountTableViewCell.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class AccountTableViewCell: UITableViewCell, NibReusable{

    @IBOutlet weak var lbname: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(_ indexImg : String ,_ indexLb : String ) {
        imgIcon.image = UIImage(named: indexImg)
        lbname.text = indexLb
    }
}
