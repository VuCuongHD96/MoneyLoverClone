//
//  EventTableViewCell.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class EventTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var txtDateLeft: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var txtCash: UILabel!
    @IBOutlet weak var txtEvent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(data: Event) {
        imgEvent.image = UIImage(named: data.image)
        txtEvent.text = data.name
    }
}
