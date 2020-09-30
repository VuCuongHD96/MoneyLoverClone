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
    
  var accountArray = ["Nhóm", "Cài đặt", "Đổi mật khẩu", "Đăng xuất"]
        var iconArray = ["group", "setting", "changepass", "logout"]

        let idAccountTableViewCell = "AccountTableViewCell"

        var myIndex = 0
        var pass = "123"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setData()
            setupTableView()
            print(pass)
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
            self.present(alert, animated: true)
        }
    }

    extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = .lightGray
            return view
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return CGFloat.leastNonzeroMagnitude
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case 0:
                return 1
            case 1:
                return 3
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
                cell.setContent(iconArray[indexPath.row + 1], accountArray[indexPath.row + 1])
            default:
                break
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.section {
            case 0:
                print("man hinh Nhom")
            case 1:
                myIndex = indexPath.row
                switch myIndex {
                case 0:
                    let settingScreen = SettingsTableViewController.instantiate()
                    settingScreen.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(settingScreen, animated: true)
                case 1:
                    let changePass = ChangePassViewController.instantiate()
                    changePass.currentPass = pass
                    navigationController?.pushViewController(changePass, animated: true)
                case 2:
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
