//
//  AccountViewController.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

class AccountViewController: UIViewController {
    
    @IBOutlet private weak var imgAccount: UIImageView!
    @IBOutlet private weak var lbNameAccount: UILabel!
    @IBOutlet private weak var lbGmailAccount: UILabel!
    @IBOutlet private weak var tableViewAccount: UITableView!
    
    var accountArray: [String] = ["Quản lý tài khoản", "Nhóm", "Cài đặt"]
    var iconArray: [String] = ["account", "group", "setting"]
    let id = "AccountTableViewCell"
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setupTableView()
    }
    
    func setData() {
        imgAccount.image = UIImage(named: "male")
        lbNameAccount.text = "Việt Hoàng"
        lbGmailAccount.text = "nguyenviethoang@gmail.com"
        lbGmailAccount.textColor = .lightGray
    }
    
    func setupTableView() {
        tableViewAccount.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: AccountTableViewCell.self)
        }
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AccountTableViewCell = tableViewAccount.dequeueReusableCell(for: indexPath)
        cell.setContent(iconArray[indexPath.row], accountArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        switch myIndex {
        case 0:
            print("man hinh quan ly tai khoan")
        case 1:
            print("man hinh Nhom")
        case 2:
//            guard let vc = storyboard?.instantiateViewController(identifier: "setting") as? SettingsTableViewController else { return  }
            let settingScreen = SettingsTableViewController.instantiate()
            navigationController?.pushViewController(settingScreen, animated: true)
        default : break
        }
    }
}
