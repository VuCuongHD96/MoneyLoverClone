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
    
    var accountArray: [String] = [ "Nhóm", "Cài đặt", "Đổi mật khẩu", "Đăng xuất"]
    var iconArray: [String] = ["group", "setting", "changepass", "logout"]
    var myIndex = 0
    var passWord = "123" , newPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setupTableView()
        print(newPass)
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
            tableViewAccount.isScrollEnabled = false
        }
    }
    
    func logout(){
        let alert = UIAlertController(title: "Nhắc nhở", message: "Bạn có chắc muốn đăng xuất khỏi thiết bị này?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .default, handler: { action in
            print("xủ lý đăng xuất ở đây")
        }
            ))
        self.present(alert, animated: true)
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = AccountSections(rawValue: section) else {
            return 0
        }
        switch section {
        case .chung:
            return 2
        case .logout:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewAccount.dequeueReusableCell(withIdentifier: "CustomCell") as! AccountTableViewCell
        guard let section = AccountSections(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .chung:
            cell.setContent(iconArray[indexPath.row], accountArray[indexPath.row])
        case .logout:
            cell.setContent(iconArray[indexPath.row+2], accountArray[indexPath.row+2])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = AccountSections(rawValue: indexPath.section) else { return }
        myIndex = indexPath.row
        switch section {
        case .chung:
             switch myIndex{
             case 0:
                 print("Màn hình Nhom")
             case 1:
                print("Màn hình setting")
             default:
                 break
             }
        case .logout:
            switch myIndex{
            case 0:
                guard let vc = storyboard?.instantiateViewController(identifier: "ChangePassViewController") as? ChangePassViewController else { return  }
                vc.currentPass = passWord
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                logout()
            default:
                break
            }
        }
    }
}
