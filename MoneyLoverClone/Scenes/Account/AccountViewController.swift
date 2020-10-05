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
    var urlString = "https://lh3.googleusercontent.com/fife/ABSRlIrutP_5kQJAnVeXD4fq3FOnplZj9Avlyxa1uHiZ8QHh8nq5Aj3iZANTl-cMSnTMyLYmVQC8j2l3BNTqD7G9NQPWzj_chlJwerw3k4zDOSNQFow_bFEZ3PF4xnS1UovOzXTNSHajP4BdUICBWxofFtNpIgqSnhWqeFr6HOq18zdvvNO9vYRScnXBQA-K9E6f2sbymlDVebea-x7LX7LXO_jMDA6tbQ9XORGWUrtwLvQmItW9w8N4kf3Hemk-6QLRxF1Gktt__E6YOk236ms_XERbRq-_btHeGIp8lYHHWIIUK_cDFjws7ap63hLgwzOBhK6xNPCgSBCqem1NWn36SfgjOOMWxXZ9sEAU07P9z8SpQLLMrfnGesxFM4OTaCnshrN4U9zJvl3TTAgiVjVhOD-oESDpfSBjTNU-CsBV-Fm01QKeYYzw7LbRfrJAtt8A-r6xkpncpYCjQ3vYcfvsA-12ie5ZDcDDA3_KnHyPcVqDU3sAb_A_BMzkXVyVu8PW84CSA57-RmFow6alL5fmlu0Lymt_KLhvVuUsRRbI4TeAPLmvuIJvjjC8Sp-qUb1jIP5yhjoEBnJdfGuCTsBiMXNPFwC1iVqDxxmn1XDawNvX1MyiMjAH8lry2uH8AUaWR-dQ1eoZrnJW0_gJ_z7BxtMHja7N6p7Qn6SPBD5n3HMOgHy2ONRylM1n8p1JcitOJcXg1MGWA6oQc7tqlK4XpjMWkQZWc2TKLvPBTG1I2Kg46g=s32-c"
    
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
        if urlString.isEmpty {
            accountImg.image = UIImage(named: "male")
        } else {
            guard let url = URL(string: urlString) else { return  }
            accountImg.load(url: url)
        }
        accountImg.layer.cornerRadius = accountImg.frame.size.width / 2
        accountImg.clipsToBounds = true
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
