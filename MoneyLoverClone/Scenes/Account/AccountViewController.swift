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
    
    @IBOutlet private weak var accountImg: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var gmailLable: UILabel!
    @IBOutlet private weak var tableViewAccount: UITableView!
    
    var accountArray = ["Nhóm", "Cài đặt", "Đổi mật khẩu", "Đăng xuất"]
    var iconArray = ["group", "setting", "changepass", "logout"]
    var myIndex = 0
    var pass = "123"
    
    struct Constant {
        static let heighForHeader: CGFloat = 45
        static let section = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setupTableView()
        print(pass)
    }
    
    func setData() {
        accountImg.image = UIImage(named: "male")
        nameLabel.text = "Việt Hoàng"
        gmailLable.text = "nguyenviethoang@gmail.com"
        gmailLable.textColor = .lightGray
    }
    
    func setupTableView() {
        tableViewAccount.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: AccountTableViewCell.self)
        }
        tableViewAccount.isScrollEnabled = false
    }
    
    func logout() {
        let alert = UIAlertController(title: "Nhắc nhở", message: "Bạn có chắc muốn đăng xuất khỏi thiết bị này?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let logoutAction = UIAlertAction(title: "Đăng xuất", style: .default, handler: { action in
            print("xủ lý đăng xuất ở đây")
        })
        alert.addAction(logoutAction)
        present(alert, animated: true)
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.section
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.heighForHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constant.section
        case 1:
            return Constant.section
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AccountTableViewCell = tableViewAccount.dequeueReusableCell(for: indexPath)
        switch indexPath.section {
        case 0:
            cell.setContent(iconArray[indexPath.row], accountArray[indexPath.row])
        case 1:
            cell.setContent(iconArray[indexPath.row + 2], accountArray[indexPath.row + 2])
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            myIndex = indexPath.row
            switch myIndex {
            case 0:
                print("Man hinh nhom")
            case 1:
                let settingScreen = SettingsTableViewController.instantiate()
                settingScreen.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(settingScreen, animated: true)
            default :
                break
            }
        case 1:
            myIndex = indexPath.row
            switch myIndex {
            case 0:
                let changePass = ChangePassViewController.instantiate()
                changePass.currentPass = pass
                changePass.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(changePass, animated: true)
            case 1:
                logout()
            default :
                break
            }
        default: break
        }
    }
}

extension AccountViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.account
}
