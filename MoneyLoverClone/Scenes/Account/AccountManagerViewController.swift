//
//  AccountManagerViewController.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class AccountManagerViewController: UIViewController {

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var lbName: UILabel!
    @IBOutlet private weak var lbGmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()

    }
    func setData() {
        image.image = UIImage(named: "accountmanager")
        lbName.text = "Việt Hoàng"
        lbGmail.text = "nguyenviethoang@gmail.com"
        lbGmail.textColor = .lightGray
    }
}
