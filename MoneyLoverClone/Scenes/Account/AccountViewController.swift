//
//  AccountViewController.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var lbNameAccount: UILabel!
    @IBOutlet weak var lbGmailAccount: UILabel!
    @IBOutlet weak var tableViewAccount: UITableView!
    
    var accountArray: [String] = ["Ví của tôi", "Nhóm", "Cài đặt"]
    var iconArray: [String] = ["myWallet", "group", "setting"]
    let id = "AccountCell"
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
        tableViewAccount.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: id)
        tableViewAccount.delegate = self
        tableViewAccount.dataSource = self
    }
}
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewAccount.dequeueReusableCell(withIdentifier: id, for: indexPath) as! AccountTableViewCell
        cell.imgIcon.image = UIImage(named: iconArray[indexPath.row])
        cell.lbName.text = accountArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        switch myIndex {
        case 0:
            print("chuyển sang màn ví của tôi")
            //performSegue(withIdentifier: "segue", sender: self)
        case 1:
            print("chuyển sang màn nhóm")
            
        case 2:
            print("chuyển sang màn Cài đặt")
        default:
            break
        }
    }
}
