//
//  EventTableViewCell.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit



class EventTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var txtDateLeft: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    @IBOutlet weak var txtCash: UILabel!
    @IBOutlet weak var txtEvent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
